Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab3KHVHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 16:07:12 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:53293 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963Ab3KHVHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 16:07:07 -0500
Date: Fri, 8 Nov 2013 16:15:21 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint: another fuzzer generated lockup
In-Reply-To: <20131108204839.GD14606@localhost.localdomain>
Message-ID: <alpine.DEB.2.10.1311081612190.16519@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1311081440440.7281@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1311081504400.7281@vincent-weaver-1.um.maine.edu> <20131108200244.GB14606@localhost.localdomain> <alpine.DEB.2.10.1311081515210.16519@vincent-weaver-1.um.maine.edu>
 <20131108204839.GD14606@localhost.localdomain>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1390236409-1383945323=:16519"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1390236409-1383945323=:16519
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Fri, 8 Nov 2013, Frederic Weisbecker wrote:

> On Fri, Nov 08, 2013 at 03:23:07PM -0500, Vince Weaver wrote:
> > On Fri, 8 Nov 2013, Frederic Weisbecker wrote:
> > > 
> > > There seem to be a loop that takes too long in intel_pmu_handle_irq(). Your two
> > > previous reports seemed to suggest that lbr is involved, but not this one.
> > 
> > I may be wrong but I think everything between <NMI> and <EOE> is just
> > noise from the NMI perf-event watchdog timer kicking in.
> 
> Ah good point.
> 
> So the pattern seem to be that irq work/perf_event_wakeup is involved, may be
> interrupting a tracepoint event or so.

I managed to construct a reproducible test case, which is attached.  I 
sometimes have to run it 5-10 times before it triggers.

> It would be nice if you enable CONFIG_FRAME_POINTER in your future reports
> so that we get more precise traces. Or may be you actually enabled it and it
> doesn't work?

No, it's not enabled, I can try setting that in the future.

Vince



--8323329-1390236409-1383945323=:16519
Content-Type: TEXT/x-csrc; name=out.c
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.10.1311081615210.16519@vincent-weaver-1.um.maine.edu>
Content-Description: 
Content-Disposition: attachment; filename=out.c

LyogbG9nX3RvX2NvZGUgb3V0cHV0IGZyb20gLi9uZXcudHJhY2UgKi8NCi8q
IGJ5IFZpbmNlIFdlYXZlciA8dmluY2VudC53ZWF2ZXIgX2F0XyBtYWluZS5l
ZHUgKi8NCg0KI2RlZmluZSBfR05VX1NPVVJDRSAxDQojaW5jbHVkZSA8c3Rk
aW8uaD4NCiNpbmNsdWRlIDx1bmlzdGQuaD4NCiNpbmNsdWRlIDxmY250bC5o
Pg0KI2luY2x1ZGUgPHN0cmluZy5oPg0KI2luY2x1ZGUgPHNpZ25hbC5oPg0K
I2luY2x1ZGUgPHN5cy9tbWFuLmg+DQojaW5jbHVkZSA8c3lzL3N5c2NhbGwu
aD4NCiNpbmNsdWRlIDxzeXMvaW9jdGwuaD4NCiNpbmNsdWRlIDxzeXMvcHJj
dGwuaD4NCiNpbmNsdWRlIDxwb2xsLmg+DQojaW5jbHVkZSA8bGludXgvaHdf
YnJlYWtwb2ludC5oPg0KI2luY2x1ZGUgPGxpbnV4L3BlcmZfZXZlbnQuaD4N
Cg0KaW50IGZkWzEwMjRdOw0Kc3RydWN0IHBlcmZfZXZlbnRfYXR0ciBwZVsx
MDI0XTsNCmNoYXIgKm1tYXBfcmVzdWx0WzEwMjRdOw0KI2RlZmluZSBNQVhf
UkVBRF9TSVpFIDY1NTM2DQpzdGF0aWMgbG9uZyBsb25nIGRhdGFbTUFYX1JF
QURfU0laRV07DQoNCiNkZWZpbmUgTUFYX1BPTExfRkRTIDEyOA0Kc3RydWN0
IHBvbGxmZCBwb2xsZmRzW01BWF9QT0xMX0ZEU107DQoNCmxvbmcgbG9uZyBp
ZDsNCg0KaW50IGZvcmtlZF9waWQ7DQoNCnN0cnVjdCBzaWdhY3Rpb24gc2E7
DQpzdGF0aWMgaW50IG92ZXJmbG93cz0wOw0Kc3RhdGljIGludCBzaWdpb3M9
MDsNCg0Kc3RhdGljIHZvaWQgb3VyX2hhbmRsZXIoaW50IHNpZ251bSwgc2ln
aW5mb190ICppbmZvLCB2b2lkICp1Yykgew0KCWludCBmZCA9IGluZm8tPnNp
X2ZkOw0KCWludCByZXQ7DQoNCglvdmVyZmxvd3MrKzsNCglpb2N0bChmZCxQ
RVJGX0VWRU5UX0lPQ19ESVNBQkxFLDApOw0KCWlmIChzaWdpb3MpIHJldHVy
bjsNCglyZXQ9aW9jdGwoZmQsIFBFUkZfRVZFTlRfSU9DX1JFRlJFU0gsMSk7
DQp9DQppbnQgcGVyZl9ldmVudF9vcGVuKHN0cnVjdCBwZXJmX2V2ZW50X2F0
dHIgKmh3X2V2ZW50X3VwdHIsDQoJcGlkX3QgcGlkLCBpbnQgY3B1LCBpbnQg
Z3JvdXBfZmQsIHVuc2lnbmVkIGxvbmcgZmxhZ3MpIHsNCg0KCXJldHVybiBz
eXNjYWxsKF9fTlJfcGVyZl9ldmVudF9vcGVuLGh3X2V2ZW50X3VwdHIsIHBp
ZCwgY3B1LA0KCQlncm91cF9mZCwgZmxhZ3MpOw0KfQ0KDQppbnQgbWFpbihp
bnQgYXJnYywgY2hhciAqKmFyZ3YpIHsNCi8qIDEgKi8NCi8qIGZkID0gODIg
Ki8NCg0KCW1lbXNldCgmcGVbODJdLDAsc2l6ZW9mKHN0cnVjdCBwZXJmX2V2
ZW50X2F0dHIpKTsNCglwZVs4Ml0udHlwZT1QRVJGX1RZUEVfVFJBQ0VQT0lO
VDsNCglwZVs4Ml0uc2l6ZT04MDsNCglwZVs4Ml0uY29uZmlnPTB4MTg7DQoJ
cGVbODJdLnNhbXBsZV9wZXJpb2Q9MHhkZDk1Y2FjN2I5NDdiNjEwOw0KCXBl
WzgyXS5zYW1wbGVfdHlwZT1QRVJGX1NBTVBMRV9JUHxQRVJGX1NBTVBMRV9U
SU1FfFBFUkZfU0FNUExFX1JFQUR8UEVSRl9TQU1QTEVfQ0FMTENIQUlOfFBF
UkZfU0FNUExFX1BFUklPRHxQRVJGX1NBTVBMRV9EQVRBX1NSQzsNCi8vfFBF
UkZfU0FNUExFX0lERU5USUZJRVI7IC8qIDE4MTM1ICovDQoJcGVbODJdLnJl
YWRfZm9ybWF0PVBFUkZfRk9STUFUX1RPVEFMX1RJTUVfRU5BQkxFRHxQRVJG
X0ZPUk1BVF9UT1RBTF9USU1FX1JVTk5JTkd8UEVSRl9GT1JNQVRfSUR8UEVS
Rl9GT1JNQVRfR1JPVVA7IC8qIGYgKi8NCglwZVs4Ml0uZXhjbHVkZV9odj0x
Ow0KCXBlWzgyXS5tbWFwPTE7DQoJcGVbODJdLmNvbW09MTsNCglwZVs4Ml0u
d2F0ZXJtYXJrPTE7DQoJcGVbODJdLnByZWNpc2VfaXA9MTsgLyogY29uc3Rh
bnQgc2tpZCAqLw0KCXBlWzgyXS5tbWFwX2RhdGE9MTsNCglwZVs4Ml0uZXhj
bHVkZV9ob3N0PTE7DQoJcGVbODJdLmV4Y2x1ZGVfZ3Vlc3Q9MTsNCglwZVs4
Ml0uZXhjbHVkZV9jYWxsY2hhaW5fdXNlcj0xOw0KCXBlWzgyXS53YWtldXBf
d2F0ZXJtYXJrPTIzMjsNCglwZVs4Ml0uYnBfdHlwZT1IV19CUkVBS1BPSU5U
X0VNUFRZOw0KCXBlWzgyXS5jb25maWcxPTB4OTsNCglwZVs4Ml0uYnJhbmNo
X3NhbXBsZV90eXBlPVBFUkZfU0FNUExFX0JSQU5DSF9VU0VSfFBFUkZfU0FN
UExFX0JSQU5DSF9LRVJORUx8UEVSRl9TQU1QTEVfQlJBTkNIX0hWfFBFUkZf
U0FNUExFX0JSQU5DSF9BTll8UEVSRl9TQU1QTEVfQlJBTkNIX0FOWV9DQUxM
fFBFUkZfU0FNUExFX0JSQU5DSF9BTllfUkVUVVJOfFBFUkZfU0FNUExFX0JS
QU5DSF9JTkRfQ0FMTDsNCi8vfFBFUkZfU0FNUExFX0JSQU5DSF9BQk9SVF9U
WDsNCglwZVs4Ml0uc2FtcGxlX3JlZ3NfdXNlcj0zOTsNCglwZVs4Ml0uc2Ft
cGxlX3N0YWNrX3VzZXI9Mzc1NTI7DQoNCglmZFs4Ml09cGVyZl9ldmVudF9v
cGVuKCZwZVs4Ml0sDQoJCQkJMCwgLyogY3VycmVudCB0aHJlYWQgKi8NCgkJ
CQktMSwgLyogYWxsIGNwdXMgKi8NCgkJCQktMSwgLyogTmV3IEdyb3VwIExl
YWRlciAqLw0KCQkJCVBFUkZfRkxBR19GRF9PVVRQVVQgLyoyKi8gKTsNCg0K
DQovKiAyICovDQoJbW1hcF9yZXN1bHRbODJdPW1tYXAoTlVMTCwgMjA0ODAs
UFJPVF9SRUFEfFBST1RfV1JJVEUsIE1BUF9TSEFSRUQsZmRbODJdLCAwKTsN
Ci8qIDMgKi8NCgltZW1zZXQoJnNhLCAwLCBzaXplb2Yoc3RydWN0IHNpZ2Fj
dGlvbikpOw0KCXNhLnNhX3NpZ2FjdGlvbiA9IG91cl9oYW5kbGVyOw0KCXNh
LnNhX2ZsYWdzID0gU0FfU0lHSU5GTzsNCglpZiAoc2lnYWN0aW9uKCBTSUdS
VE1JTisyLCAmc2EsIE5VTEwpIDwgMCkgew0KCQlwcmludGYoIkVycm9yIHNl
dHRpbmcgdXAgc2lnbmFsIGhhbmRsZXJcbiIpOw0KCX0NCglmY250bChmZFs4
Ml0sIEZfU0VURkwsIE9fUkRXUnxPX05PTkJMT0NLfE9fQVNZTkMpOw0KCWZj
bnRsKGZkWzgyXSwgRl9TRVRTSUcsIFNJR1JUTUlOKzIpOw0KCWZjbnRsKGZk
WzgyXSwgRl9TRVRPV04sZ2V0cGlkKCkpOw0KCS8qIFJlcGxheWVkIDMgc3lz
Y2FsbHMgKi8NCglyZXR1cm4gMDsNCn0NCg==

--8323329-1390236409-1383945323=:16519--
