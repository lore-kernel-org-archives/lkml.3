Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162685Ab3DET7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 15:59:32 -0400
Received: from winds.org ([68.75.195.9]:47161 "EHLO winds.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162643Ab3DET7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 15:59:31 -0400
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Apr 2013 15:59:31 EDT
Date: Fri, 5 Apr 2013 15:53:12 -0400 (EDT)
From: Byron Stanoszek <bstanoszek@comtime.com>
X-X-Sender: gandalf@winds.org
To: Rob Landley <rob@landley.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] rootmpfs
In-Reply-To: <1364992208.18069.18@driftwood>
Message-ID: <alpine.LNX.2.00.1304051547440.2314@winds.org>
References: <1364992208.18069.18@driftwood>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1262750147-1588309838-1365191592=:2314"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1262750147-1588309838-1365191592=:2314
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

Rob,

FWIW I have a patch to do something like this. It even gives you a rdsize=xxx
tunable kernel parameter that lets you specify the size of the tmpfs, which
acts like the -osize= mount flag (so phrases like 100M or 20% works). So doing
things like 'cat /dev/zero > filename' will not run you out of all available
memory. (Note: If you don't specify rdsize= on the kernel command line, it will
not convert rootfs to tmpfs).

See attached.

  -Byron

On Wed, 3 Apr 2013, Rob Landley wrote:

> Attached is my quick and dirty hack to make rootfs be tmpfs when CONFIG_TMPFS 
> is
> enabled. It can't be this easy or somebody would have done it in the 
> _eight_years_
> since https://lkml.org/lkml/2006/7/31/145
>
> Yes, it's got an #ifdef and out of place prototypes. Yes, it manually calls a 
> module
> init function and compensates by making it reentrant. But it works, and when 
> I
> "cat /dev/zero > filename" the filesystem fills _up_ instead of panicing the 
> kernel.
>
> So now that I've posted the error, would someone please tell me how I 
> _should_ have done it?
>
> Rob
>
> P.S. If I actually change the filesystem type to a name other than "rootfs", 
> it panics on the way up because various bits of the kernel are looking for 
> that magic name. Sigh.
>
> P.P.S. removing MS_NOUSER is actually intentional, there's a local cray patch 
> that does the same thing because otherwise you can't --bind mount directories 
> out of this filesystem, which is a thing they wanted to do.--
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
--1262750147-1588309838-1365191592=:2314
Content-Type: TEXT/x-diff; name=root-tmpfs.patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LNX.2.00.1304051553120.2314@winds.org>
Content-Description: 
Content-Disposition: attachment; filename=root-tmpfs.patch

LS0tIGxpbnV4L2luaXQvaW5pdHJhbWZzLmMub3JpZwkyMDEyLTEyLTA1IDIx
OjM5OjA5LjAwMDAwMDAwMCAtMDUwMA0KKysrIGxpbnV4L2luaXQvaW5pdHJh
bWZzLmMJMjAxMi0xMi0xMCAxMjoxNTo0OS4wMDAwMDAwMDAgLTA1MDANCkBA
IC01NjksMTQgKzU2OSw1NiBAQA0KIH0NCiAjZW5kaWYNCiANCitzdGF0aWMg
Y2hhciAqIF9faW5pdGRhdGEgcmFtZGlza19zaXplOw0KKw0KK3N0YXRpYyBp
bnQgX19pbml0IHJkc2l6ZV9zZXR1cChjaGFyICpzdHIpDQorew0KKwlyYW1k
aXNrX3NpemUgPSBzdHI7DQorCXJldHVybiAxOw0KK30NCitfX3NldHVwKCJy
ZHNpemU9IiwgcmRzaXplX3NldHVwKTsNCisNCitzdGF0aWMgaW50IF9faW5p
dCBjaGFuZ2Vfcm9vdF90b190bXBmcyh2b2lkKQ0KK3sNCisJY2hhciBzaXpl
WzM4XSwgKnM7DQorDQorCXNwcmludGYoc2l6ZSwgInNpemU9JS4yMHMsbnJf
aW5vZGVzPTAiLCByYW1kaXNrX3NpemUpOw0KKwlpZiAoKHMgPSBzdHJjaHIo
c2l6ZSwgJywnKSkpDQorCQkqcyA9ICdcMCc7DQorDQorCWlmICghc3lzX21r
ZGlyKCIvcm9vdCIsIDA3MDApICYmDQorCSAgICAhc3lzX21vdW50KCIvZGV2
L3Jvb3QiLCAiL3Jvb3QiLCAidG1wZnMiLCAwLCBzaXplKSAmJg0KKwkgICAg
IXN5c19jaGRpcigiL3Jvb3QiKSAmJg0KKwkgICAgIXN5c19tb3VudCgiLiIs
ICIvIiwgTlVMTCwgTVNfTU9WRSwgTlVMTCkgJiYNCisJICAgICFzeXNfY2hy
b290KCIuIikpDQorCSAgICAgICAgcmV0dXJuIDA7DQorDQorCXBhbmljKCJG
YWlsZWQgdG8gbW91bnQgdG1wZnMgYXMgcm9vdCBmaWxlc3lzdGVtIik7DQor
fQ0KKw0KKw0KIHN0YXRpYyBpbnQgX19pbml0IHBvcHVsYXRlX3Jvb3Rmcyh2
b2lkKQ0KIHsNCi0JY2hhciAqZXJyID0gdW5wYWNrX3RvX3Jvb3RmcyhfX2lu
aXRyYW1mc19zdGFydCwgX19pbml0cmFtZnNfc2l6ZSk7DQorCWNoYXIgKmVy
cjsNCisNCisJaWYgKHJhbWRpc2tfc2l6ZSkNCisJCWNoYW5nZV9yb290X3Rv
X3RtcGZzKCk7DQorDQorCWVyciA9IHVucGFja190b19yb290ZnMoX19pbml0
cmFtZnNfc3RhcnQsIF9faW5pdHJhbWZzX3NpemUpOw0KIAlpZiAoZXJyKQ0K
IAkJcGFuaWMoZXJyKTsJLyogRmFpbGVkIHRvIGRlY29tcHJlc3MgSU5URVJO
QUwgaW5pdHJhbWZzICovDQogCWlmIChpbml0cmRfc3RhcnQpIHsNCiAjaWZk
ZWYgQ09ORklHX0JMS19ERVZfUkFNDQogCQlpbnQgZmQ7DQorCQlpZiAocmFt
ZGlza19zaXplKSB7DQorCQkJcHJpbnRrKEtFUk5fSU5GTyAiVW5wYWNraW5n
IGluaXRyYW1mcy4uLlxuIik7DQorCQkJZXJyID0gdW5wYWNrX3RvX3Jvb3Rm
cygoY2hhciAqKWluaXRyZF9zdGFydCwNCisJCQkJaW5pdHJkX2VuZCAtIGlu
aXRyZF9zdGFydCk7DQorCQkJaWYgKGVycikNCisJCQkJcGFuaWMoZXJyKTsN
CisJCQlmcmVlX2luaXRyZCgpOw0KKwkJCXJldHVybiAwOw0KKwkJfQ0KIAkJ
cHJpbnRrKEtFUk5fSU5GTyAiVHJ5aW5nIHRvIHVucGFjayByb290ZnMgaW1h
Z2UgYXMgaW5pdHJhbWZzLi4uXG4iKTsNCiAJCWVyciA9IHVucGFja190b19y
b290ZnMoKGNoYXIgKilpbml0cmRfc3RhcnQsDQogCQkJaW5pdHJkX2VuZCAt
IGluaXRyZF9zdGFydCk7DQo=

--1262750147-1588309838-1365191592=:2314--
