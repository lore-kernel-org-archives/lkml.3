Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaIBLXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:23:19 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65443 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbaIBLXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:23:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140902110337.GA5049@thunk.org>
References: <20140902040527.GA5508@thunk.org>
	<CAPM=9txYd6LBojX+y5TYdW=8O=v49mcodj4iBZAmytXTRL68LA@mail.gmail.com>
	<20140902110337.GA5049@thunk.org>
Date: Tue, 2 Sep 2014 21:23:16 +1000
Message-ID: <CAPM=9txM1HnJHdT=B03Nd4oawAy23a4Uen66kz8g5nG655WQ=Q@mail.gmail.com>
Subject: Re: [REGRESSION] i915: failure to see Dell 30" monitor connected to a
 Lenovo Haswell docking station
From: Dave Airlie <airlied@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jani Nikula <jani.nikula@intel.com>
Content-Type: multipart/mixed; boundary=089e0158c8d48a2bb805021358aa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0158c8d48a2bb805021358aa
Content-Type: text/plain; charset=UTF-8

On 2 September 2014 21:03, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Sep 02, 2014 at 02:15:39PM +1000, Dave Airlie wrote:
>> On 2 September 2014 14:05, Theodore Ts'o <tytso@mit.edu> wrote:
>> > I recently upgraded to v3.17-rc3, and on my Lenovo T540p, I can no
>> > longer see the my Dell 30" monitor when it is connected via the
>> > docking station using a Displayport connector.  This worked using 3.16
>> > kernel.
>> >
>> > If I connect to the monitor using the mini-display, by passing the
>> > docking station, things work fine (but of course it's annoying not to
>> > be able to use the docking station).
>> >
>> > Is this a known problem?  This is not the first time that we've had
>> > regressions with this docking station.   It's vaguely reminsicent of
>> >
>> >         https://bugs.freedesktop.org/show_bug.cgi?id=71267
>> >
>> > Except the system isn't hanging; it's just not seeing the monitor at all.
>>
>> Have you the Dell 30" set to Displayport 1.2 enabled mode?
>
> No, it DP 1.2 was disabled.  If I enable it, it breaks things when I
> try connecting via the MiniDP port (bypassing the dock), and it is
> still broken when I try to talk via the DisplayPort in the dock.
>
> If I disable DP 1.2 again, it works via the MiniDP port, but if I try
> to connect through the dock (which has a DP Hub which I believe is
> MST/DP 1.2 capable), it is still broken.
>
> It does seem that this might be related to 3.17-rc3 trying to talk DP
> 1.2 if it is available, since I can't control what the DP hub in the
> docking station advertises --- is there a commit or some kind of hack
> I can try to force talking to the DP hub using DP 1.1?
>

Interesting, I have the same combo of hw available on my desk at work,
but it might be a couple of days before I can get to the office to
debug it,

can you boot with drm.debug=6 and get me the dmesg?

The attached hack turns off mst so might be useful as a workaround,
but I should be able to fix this once I sit down at my desk.

Dave.

--089e0158c8d48a2bb805021358aa
Content-Type: text/x-patch; charset=US-ASCII; name="i915-mst-hack.patch"
Content-Disposition: attachment; filename="i915-mst-hack.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hzl5crdk0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX2RwLmMgYi9kcml2ZXJzL2dw
dS9kcm0vaTkxNS9pbnRlbF9kcC5jCmluZGV4IDZkYjg0YmYuLjU2ODI0OWUgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX2RwLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL2k5
MTUvaW50ZWxfZHAuYwpAQCAtMzM5Miw2ICszMzkyLDcgQEAgaW50ZWxfZHBfcHJvYmVfbXN0KHN0
cnVjdCBpbnRlbF9kcCAqaW50ZWxfZHApCiB7CiAJdTggYnVmWzFdOwogCisJcmV0dXJuIGZhbHNl
OwogCWlmICghaW50ZWxfZHAtPmNhbl9tc3QpCiAJCXJldHVybiBmYWxzZTsKIAo=
--089e0158c8d48a2bb805021358aa--
