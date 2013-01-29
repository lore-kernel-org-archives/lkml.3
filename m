Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab3A2DTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 22:19:48 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:41969 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3A2DTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 22:19:46 -0500
MIME-Version: 1.0
In-Reply-To: <CAKocOOMD9i7TtzoH3c2pDXqSRXV8RB1qmqp_QxftCpfK763CqA@mail.gmail.com>
References: <CA+55aFx5ZyFtd59ygn6ja5X-3ZyRvhfJLqtNKyF_mH3+-kSjKg@mail.gmail.com>
	<CAKocOOPr4wddCmDEWKmsKsKeTc3m779opuN_qRb4yiL63KVZ8A@mail.gmail.com>
	<CAKocOOPp1PA-n_=xdPuBSBKaKiREqhgeo02QqWpP-oX7vnN_YA@mail.gmail.com>
	<CAKocOOOpDb=0XgX-uhDbBjOF7qK_M5MA31q9ScD0yTat0QRquQ@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DC30FE7@sausexdag04.amd.com>
	<CAKocOONuFvcik229+1B0oeaBnQG7seZPeYf99xqduFa6kBZhOw@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF083DE@sausexdag04.amd.com>
	<CAKocOOMxAYw-XO-6XGteKb8NyHDq4_BdZn2njUNBh+a73wrFGA@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF084EA@sausexdag04.amd.com>
	<CAKocOOOYKAZPH1+W3usfRUh68594e8YKqBUORo2c5bCCCYDh0A@mail.gmail.com>
	<CAKocOOOaWSvWZkhLNBx9u6M5nOu39wUgnS-a9Srsbp5BTcdh1A@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF086E6@sausexdag04.amd.com>
	<CAKocOOMD9i7TtzoH3c2pDXqSRXV8RB1qmqp_QxftCpfK763CqA@mail.gmail.com>
Date: Mon, 28 Jan 2013 20:19:43 -0700
Message-ID: <CAKocOONFpPBQH=naKdmrXa1ijpzf=0jonKuUWbw3NhEeumfM=A@mail.gmail.com>
Subject: Re: Linux 3.8-rc4
From: Shuah Khan <shuahkhan@gmail.com>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=bcaec553ff0c76791304d464dd0d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec553ff0c76791304d464dd0d
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Jan 23, 2013 at 11:44 AM, Shuah Khan <shuahkhan@gmail.com> wrote:
> On Wed, Jan 23, 2013 at 6:40 AM, Deucher, Alexander
> <Alexander.Deucher@amd.com> wrote:
>>> -----Original Message-----
>>> From: Shuah Khan [mailto:shuahkhan@gmail.com]
>>> Sent: Tuesday, January 22, 2013 6:57 PM
>>> To: Deucher, Alexander
>>> Cc: Linus Torvalds; Linux Kernel Mailing List
>>> Subject: Re: Linux 3.8-rc4
>>>
>>> On Tue, Jan 22, 2013 at 11:55 AM, Shuah Khan <shuahkhan@gmail.com>
>>> wrote:
>>>
>>> >>> init:
>>> >>
>>> >> Does the attached patch stop them?  It basically skips all initialization of
>>> the DMA ring on your system.  What I don't understand is why you still get
>>> them with the previous patch, but not with
>>> 909d9eb67f1e4e39f2ea88e96bde03d560cde3eb reverted.
>>> 909d9eb67f1e4e39f2ea88e96bde03d560cde3eb only affects the use of the
>>> DMA ring for buffer migration and the patch I previously attached disables
>>> the use of the DMA ring for buffer migration.  Does the latest batch of drm-
>>> fixes from Dave that Linus just merged help?
>>> >>
>>> >> Alex
>>> >
>>> > Will try your latest patch. Will also try the latest git - I am
>>> > currently on Jan 17th. However, in the meantime, I found that these
>>> > messages might not be new and getting printed now with the
>>> > eaaa6983ab2ccdf826c90838eb584211e0cadb76 [PATCH] drm/radeon: print
>>> dma
>>> > status reg on lockup (v2) commit that introduced debug messages in
>>> > r600_gpu_soft_reset(). I couldn't revert this commit, but doing a
>>> > compile with these messages commented out. Will update you on the
>>> > results and then test the new git
>>> >
>>> > -- Shuah
>>>
>>> Here is what I tried:
>>>
>>> 1. Applied your latest disable_dma_ring_on_6xx-2.diff and still see
>>> messages.
>>
>> If that is the case, I'm beginning to think the bug is elsewhere.  Support for the DMA ring was the only major feature we added in this cycle.  If you are still getting errors even with the ring completely disabled, it's probably not the DMA ring.
>>
>> Make sure your kernel has this patch:
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=20707874fd4fd37e09513f508e642fa8bd06365a
>> That's the only thing I can think of that may cause the DMAR errors if the DMA ring is disabled.
>>
>
> I verified I have this commit. ok maybe the bug is elsewhere. So far
> all my bisects are on drivers/gpu/drm/radeon - I am going go one more
> level up and start at drivers/gpu/drm and see what I can isolate it
> that way. I do know that I don't see this problem on 3.7.4
>
> -- Shuah

Alex,

I was out sick for a few days and finally picked this bisect backup
again. I started at 3.7 tag instead of 3.8-rc1 that I did in the past
and also did bisect at drivers/gpu/drm/radeon instead. Here are the
results:

6253e4c75d96006c06b9ac8f417eba873de2497b is the first bad commit
commit 6253e4c75d96006c06b9ac8f417eba873de2497b
Author: Alex Deucher <alexander.deucher@amd.com>
Date:   Wed Dec 12 14:30:32 2012 -0500

    drm/radeon: improve mc_stop/mc_resume on r5xx-r7xx

    Along the same lines of what was done for evergreen+
    in the last kernel.

    Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

git bisect log attached.

I am going to try doing a revert on this commit tomorrow and see if
that clears the problem.

-- Shuah

--bcaec553ff0c76791304d464dd0d
Content-Type: application/octet-stream; name=git_bisect_log_jan28
Content-Disposition: attachment; filename=git_bisect_log_jan28
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hcih835r0

Z2l0IGJpc2VjdCBzdGFydCAnLS0nICdkcml2ZXJzL2dwdS9kcm0nCiMgZ29vZDogWzI5NTk0NDA0
ZDdmZTczY2Q4MGVhYTRlZThjNDNkY2M1Mzk3MGM2MGVdIExpbnV4IDMuNwpnaXQgYmlzZWN0IGdv
b2QgMjk1OTQ0MDRkN2ZlNzNjZDgwZWFhNGVlOGM0M2RjYzUzOTcwYzYwZQojIGJhZDogWzhmMGQ4
MTYzYjUwZTAxZjM5OGIxNGJjZDRkYzAzOWFjNWFiMThkNjRdIExpbnV4IDMuNy1yYzMKZ2l0IGJp
c2VjdCBiYWQgOGYwZDgxNjNiNTBlMDFmMzk4YjE0YmNkNGRjMDM5YWM1YWIxOGQ2NAojIGJhZDog
Wzk5MzFmYWNhMDJjNjA0YzIyMzM1ZjVhOTM1YTUwMWJiMmFjZTZlMjBdIExpbnV4IDMuOC1yYzMK
Z2l0IGJpc2VjdCBiYWQgOTkzMWZhY2EwMmM2MDRjMjIzMzVmNWE5MzVhNTAxYmIyYWNlNmUyMAoj
IHNraXA6IFs5NDQyMzRkNmEyYzQ2YTQ2NjY1MzM5MDRiN2VhOGM3OTgwN2U5MDcyXSBkcm0vbnY1
MC9kaXNwOiBhbGxvdyBQQ0lfVVMgcHVzaGJ1ZiBiaW5kaW5nCmdpdCBiaXNlY3Qgc2tpcCA5NDQy
MzRkNmEyYzQ2YTQ2NjY1MzM5MDRiN2VhOGM3OTgwN2U5MDcyCiMgc2tpcDogW2U1ZTQ1NGY5MTgw
NTFlNGZmNGJlOTg3NzdlZTI1NDM3ZDQ4YzNhMWVdIGRybS9udmMwL2NvcHk6IHNoYXJlIGludGVy
cnVwdCBoYW5kbGVyIHdpdGggbnZhMwpnaXQgYmlzZWN0IHNraXAgZTVlNDU0ZjkxODA1MWU0ZmY0
YmU5ODc3N2VlMjU0MzdkNDhjM2ExZQojIHNraXA6IFs3NmU0MzgzMDM0MDNmMzAxZjM1MDk0Nzli
NTQ0ZTQxNTE4ZWRkMDU5XSBkcm0vaTkxNTogbW92ZSBocGQgaGFuZGxpbmcgdG8gKGlieHxjcHQp
X2lycV9oYW5kbGVyCmdpdCBiaXNlY3Qgc2tpcCA3NmU0MzgzMDM0MDNmMzAxZjM1MDk0NzliNTQ0
ZTQxNTE4ZWRkMDU5CiMgc2tpcDogW2JlN2NiNjM0N2UwYzNhYTE5NTY3NDhhODYwYTI0NjVhN2Vh
MTI4YzRdIGRybS9pOTE1OiBSZW1vdmUgYm9ndXMgdGVzdCBmb3IgYSBwcmVzZW50IGV4ZWNidWZm
ZXIKZ2l0IGJpc2VjdCBza2lwIGJlN2NiNjM0N2UwYzNhYTE5NTY3NDhhODYwYTI0NjVhN2VhMTI4
YzQKIyBiYWQ6IFs4YmUwZTVjNDI3YzE4YTU5Y2UyNjFjNDk2YWUyMTkzY2JjYmFmZmZkXSBNZXJn
ZSBicmFuY2ggJ2RybS1pbnRlbC1maXhlcycgb2YgZ2l0Oi8vcGVvcGxlLmZyZWVkZXNrdG9wLm9y
Zy9+ZGFudmV0L2RybS1pbnRlbCBpbnRvIGRybS1uZXh0CmdpdCBiaXNlY3QgYmFkIDhiZTBlNWM0
MjdjMThhNTljZTI2MWM0OTZhZTIxOTNjYmNiYWZmZmQKIyBza2lwOiBbNWY4ZTI1NjcwNGU4NmRm
Nzk1MDM3YjE4Mzk1ZmRmMTAyYjc1MTk5ZV0gZHJtL252NDAvZmI6IHN0YXJ0IGJhc2hpbmcgemNv
bXAgcmVnaXN0ZXJzIG9uIHJlbGV2YW50IGNoaXBzZXRzCmdpdCBiaXNlY3Qgc2tpcCA1ZjhlMjU2
NzA0ZTg2ZGY3OTUwMzdiMTgzOTVmZGYxMDJiNzUxOTllCiMgc2tpcDogW2Y0Yzk1NmFkYzc5Zjg1
MmUxZjA2NDY3OWMyODQ3YjhlY2UyY2QxNmZdIGRybS9pOTE1OiBtb3ZlIHRoZSBzdXNwZW5kL3Jl
c3VtZSByZWdpc3RlciBmaWxlIG91dCBvZiBkZXZfcHJpdgpnaXQgYmlzZWN0IHNraXAgZjRjOTU2
YWRjNzlmODUyZTFmMDY0Njc5YzI4NDdiOGVjZTJjZDE2ZgojIHNraXA6IFtiNWM2MjE1ODRiYTU3
ZTYxMTI4NjRkY2Q3OWI3MTAyMGM5NTI1ZjZhXSBkcm0vaTkxNTogVXNlIHBjaV9yZXNvdXJjZSBm
dW5jdGlvbnMgZm9yIEJBUnMuCmdpdCBiaXNlY3Qgc2tpcCBiNWM2MjE1ODRiYTU3ZTYxMTI4NjRk
Y2Q3OWI3MTAyMGM5NTI1ZjZhCiMgc2tpcDogWzNmNjllNzYwNWQ2YjA3MmI5ODkwODQ1YmI2ZDlm
OTgyYmNkODc5ZWNdIGRybS9ub3V2ZWF1OiByZW1vdmUgbWlzbGVhZGluZyBjb21tZW50IGZyb20g
bm91dmVhdV9wcmltZV9uZXcKZ2l0IGJpc2VjdCBza2lwIDNmNjllNzYwNWQ2YjA3MmI5ODkwODQ1
YmI2ZDlmOTgyYmNkODc5ZWMKIyBza2lwOiBbNTc3NDUwNmYxNTdhOTE0MDBjNTg3Yjg1ZDFjZTRk
ZTU2ZjBkMzJmNl0gZHJtL2k5MTU6IEJvcnJvdyBvdXIgc3RydWN0X211dGV4IGZvciB0aGUgZGly
ZWN0IHJlY2xhaW0KZ2l0IGJpc2VjdCBza2lwIDU3NzQ1MDZmMTU3YTkxNDAwYzU4N2I4NWQxY2U0
ZGU1NmYwZDMyZjYKIyBza2lwOiBbZDY0MGM0YjA5YTVkODNhODE2N2ViMDlkMjJiZDg5ZDlmYTdl
M2I5MV0gZHJtL2k5MTU6IFJlcG9ydCBhbW91bnQgb2YgdXNhYmxlIGdyYXBoaWNzIG1lbW9yeSBp
biBNaUIKZ2l0IGJpc2VjdCBza2lwIGQ2NDBjNGIwOWE1ZDgzYTgxNjdlYjA5ZDIyYmQ4OWQ5ZmE3
ZTNiOTEKIyBnb29kOiBbYjE4MGI1ZDFjN2FjOTMwMzg3NzM0NjY0ODAyZmMyNmZhNzg4ZTI2Zl0g
ZHJtOiBCZSBtb3JlIHBhcmFub2lkIHdpdGggaW50ZWdlciBvdmVyZmxvd3MKZ2l0IGJpc2VjdCBn
b29kIGIxODBiNWQxYzdhYzkzMDM4NzczNDY2NDgwMmZjMjZmYTc4OGUyNmYKIyBza2lwOiBbOTYw
ODFjZGZhZTM1YzFlMzMyYmU0MmQ4OWRlZTI3OGM3MmQ4OTE1ZF0gZHJtL2RybV9mYl9oZWxwZXI6
IFJlbW92ZSB1bm5lY2Vzc2FyeSBicmFjZXMKZ2l0IGJpc2VjdCBza2lwIDk2MDgxY2RmYWUzNWMx
ZTMzMmJlNDJkODlkZWUyNzhjNzJkODkxNWQKIyBza2lwOiBbNzFiZmU5MTZlYmU2ZDAyNmNkM2Qw
ZTQxYzM5ODU3NGZjMTIyOGUwM10gZHJtL3JhZGVvbjogYnVtcCBkcml2ZXIgdmVyc2lvbiBmb3Ig
bmV3IGluZm8gaW9jdGwgcmVxdWVzdHMKZ2l0IGJpc2VjdCBza2lwIDcxYmZlOTE2ZWJlNmQwMjZj
ZDNkMGU0MWMzOTg1NzRmYzEyMjhlMDMKIyBza2lwOiBbZDhmNGE5ZWRhMDA2Nzg4ZDgwNTRiODUw
MGQ5ZWI1YjZlZmNkODc1NV0gZHJtOiBBZGQgTlZJRElBIFRlZ3JhMjAgc3VwcG9ydApnaXQgYmlz
ZWN0IHNraXAgZDhmNGE5ZWRhMDA2Nzg4ZDgwNTRiODUwMGQ5ZWI1YjZlZmNkODc1NQojIHNraXA6
IFs1ZGRmNGQ0YTU0M2RkMzMwM2IyMGQ3ZTlhNGIzNTQ5NTg5YzVmMDk1XSBkcm0vbm91dmVhdS9i
aW9zOiBjYWNoZSByYW1jZmcgc3RyYXAgb24gbGF0ZXIgY2hpcHNldHMKZ2l0IGJpc2VjdCBza2lw
IDVkZGY0ZDRhNTQzZGQzMzAzYjIwZDdlOWE0YjM1NDk1ODljNWYwOTUKIyBnb29kOiBbZTYyZjJm
NWFjYmExZDQ2NmRhMDQ3OTgzYWUxNmY2Yjk2YjY4YjMxMF0gZHJtOiB1c2UgbW9ub3RvbmljIHRp
bWUgaW4gZHJtX2NhbGNfdmJsdGltZXN0YW1wX2Zyb21fc2Nhbm91dHBvcwpnaXQgYmlzZWN0IGdv
b2QgZTYyZjJmNWFjYmExZDQ2NmRhMDQ3OTgzYWUxNmY2Yjk2YjY4YjMxMAojIGdvb2Q6IFs3MTM2
NDcwZDRiMzdiNDY1NjViMjliOGI5NDI1YTgzNjE0MjE0ODNiXSBNZXJnZSBicmFuY2ggJ2Zvci1h
aXJsaWVkJyBvZiBnaXQ6Ly9wZW9wbGUuZnJlZWRlc2t0b3Aub3JnL35kYW52ZXQvZHJtLWludGVs
IGludG8gZHJtLW5leHQKZ2l0IGJpc2VjdCBnb29kIDcxMzY0NzBkNGIzN2I0NjU2NWIyOWI4Yjk0
MjVhODM2MTQyMTQ4M2IKIyBza2lwOiBbYTBlNDFiNTYyYjNlMzAyYjQ3Zjg4NzA1NmQ4OTE4OWI4
MTZjZTIxOV0gZHJtL2V4eW5vcy9pb21tdTogZml4IHJldHVybiB2YWx1ZSBjaGVjayBpbiBkcm1f
Y3JlYXRlX2lvbW11X21hcHBpbmcoKQpnaXQgYmlzZWN0IHNraXAgYTBlNDFiNTYyYjNlMzAyYjQ3
Zjg4NzA1NmQ4OTE4OWI4MTZjZTIxOQojIGdvb2Q6IFs5N2E4NzVjYmRmODlhNDYzOGVlYTU3YzJi
NDU2YzdjYzRlM2U4YjIxXSBkcm0vdHRtOiByZW1vdmUgbm9fd2FpdF9yZXNlcnZlLCB2MwpnaXQg
YmlzZWN0IGdvb2QgOTdhODc1Y2JkZjg5YTQ2MzhlZWE1N2MyYjQ1NmM3Y2M0ZTNlOGIyMQojIHNr
aXA6IFsyZjNmMjQwNjFjNWM0ODkwNzRhZDQ5MmJmNjk0YTVhNzZlYmQ4ZmM1XSBNZXJnZSBicmFu
Y2ggJ2V4eW5vcy1kcm0tbmV4dCcgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L2RhZWlua2kvZHJtLWV4eW5vcyBpbnRvIGRybS1uZXh0CmdpdCBiaXNlY3Qg
c2tpcCAyZjNmMjQwNjFjNWM0ODkwNzRhZDQ5MmJmNjk0YTVhNzZlYmQ4ZmM1CiMgc2tpcDogWzYw
YTcwNWE5Zjk3YjgzYjFkYWYwMzI5NWJmMTIzYWY4NGE0NjExNmFdIGRybS9leHlub3M6IGZpeCBm
YiBvZmZzZXQgY2FsY3VsYXRpb24gZm9yIHBsYW5lCmdpdCBiaXNlY3Qgc2tpcCA2MGE3MDVhOWY5
N2I4M2IxZGFmMDMyOTViZjEyM2FmODRhNDYxMTZhCiMgYmFkOiBbOWFmMjA3OTIxMjQ4NTAzNjll
NzY0OTY1NjkwYjk5YjIwNjIzZGZjNF0gZHJtL3JhZGVvbjogZml4IGZlbmNlIGxvY2tpbmcgaW4g
dGhlIHBhZ2VmbGlwIGNhbGxiYWNrCmdpdCBiaXNlY3QgYmFkIDlhZjIwNzkyMTI0ODUwMzY5ZTc2
NDk2NTY5MGI5OWIyMDYyM2RmYzQKIyBnb29kOiBbYTYzNmE5ODI5MTc1OTg3ZTc0ZGRkMjhhMmU4
N2VkMTdmZjdhZGZkY10gTWVyZ2UgYnJhbmNoICdkcm0tbmV4dC0zLjgnIG9mIGdpdDovL3Blb3Bs
ZS5mcmVlZGVza3RvcC5vcmcvfmFnZDVmL2xpbnV4IGludG8gZHJtLW5leHQKZ2l0IGJpc2VjdCBn
b29kIGE2MzZhOTgyOTE3NTk4N2U3NGRkZDI4YTJlODdlZDE3ZmY3YWRmZGMKIyBiYWQ6IFs4Nzcw
Yjg2YjNlMDJjM2UzMGYyZmZjNDI3NTNmZjlkNjJiYzQyOGJmXSBkcm0vcmFkZW9uOiBhZGQgc3Vw
cG9ydCBmb3IgQ1AgRE1BIHBhY2tldCB0byBldmVyZ3JlZW4gQ1MgY2hlY2tlcgpnaXQgYmlzZWN0
IGJhZCA4NzcwYjg2YjNlMDJjM2UzMGYyZmZjNDI3NTNmZjlkNjJiYzQyOGJmCiMgYmFkOiBbNjI1
M2U0Yzc1ZDk2MDA2YzA2YjlhYzhmNDE3ZWJhODczZGUyNDk3Yl0gZHJtL3JhZGVvbjogaW1wcm92
ZSBtY19zdG9wL21jX3Jlc3VtZSBvbiByNXh4LXI3eHgKZ2l0IGJpc2VjdCBiYWQgNjI1M2U0Yzc1
ZDk2MDA2YzA2YjlhYzhmNDE3ZWJhODczZGUyNDk3YgojIGdvb2Q6IFtiZDI1ZjA3ODNkYzNmYjcy
ZTFlMjc3OWMyYjk5YjJkMzRiNjdmYThhXSBkcm0vcmFkZW9uOiBmaXggYW1kIGFmdXNpb24gZ3B1
IHNldHVwIGFrYSBzdW1vIHYyCmdpdCBiaXNlY3QgZ29vZCBiZDI1ZjA3ODNkYzNmYjcyZTFlMjc3
OWMyYjk5YjJkMzRiNjdmYThhCg==
--bcaec553ff0c76791304d464dd0d--
