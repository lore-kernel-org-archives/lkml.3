Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab3LLHeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:34:50 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:36463 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab3LLHep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:34:45 -0500
MIME-Version: 1.0
In-Reply-To: <52A8D2DA.7050409@gmail.com>
References: <1386756980-23121-1-git-send-email-artagnon@gmail.com> <52A8D2DA.7050409@gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Thu, 12 Dec 2013 13:04:04 +0530
Message-ID: <CALkWK0ksAB1xkaCR5jxaN-4n1KL3yQACp_62=ijmFZjj8KNuew@mail.gmail.com>
Subject: Re: [PATCH] perf list: fix --raw-dump
To: David Ahern <dsahern@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: multipart/mixed; boundary=089e0117689f28835404ed516198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0117689f28835404ed516198
Content-Type: text/plain; charset=UTF-8

David Ahern wrote:
> Why not make raw_dump a proper argument?

Sure, that'd work too. I was thinking of a minimal way to fix the
problem myself.

> diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
> index 011195e38f21..b553d0c4ca82 100644
> --- a/tools/perf/builtin-list.c
> +++ b/tools/perf/builtin-list.c
> @@ -36,6 +38,10 @@ int cmd_list(int argc, const char
>              print_events(NULL, false);
>              return 0;
>        }
> +      if (raw_dump) {
> +            print_events(NULL, true);
> +            return 0;
> +      }

This won't work because you've put it right below the `if (argc ==
0)`, which executes print_events(). You could move it up and get it to
work.

--089e0117689f28835404ed516198
Content-Type: text/x-patch; charset=US-ASCII; name="0001-perf-list-Fix-raw-dump-arg.patch"
Content-Disposition: attachment; 
	filename="0001-perf-list-Fix-raw-dump-arg.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hp3ow1d61

RnJvbSA3MTk4YTQ5NGNmZWY0MzM5NWU4NjgzYWMzYTA1NzYyNzdiOGQxZDgwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZpZCBBaGVybiA8ZHNhaGVybkBnbWFpbC5jb20+CkRhdGU6
IFdlZCwgMTEgRGVjIDIwMTMgMTQ6MDA6MjAgLTA3MDAKU3ViamVjdDogW1BBVENIXSBwZXJmIGxp
c3Q6IEZpeCByYXctZHVtcCBhcmcKClJhbWt1bWFyIHJlcG9ydGVkIHRoYXQgcGVyZiBsaXN0IC0t
cmF3LWR1bXAgd2FzIGJyb2tlbiBieSA0NGQ3NDJlLgpGaXggYnkgbWFraW5nIHJhdy1kdW1wIGEg
cHJvcGVyIGFyZ3VtZW50LgoKU2lnbmVkLW9mZi1ieTogRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21h
aWwuY29tPgpDYzogSW5nbyBNb2xuYXIgPG1pbmdvQGtlcm5lbC5vcmc+CkNjOiBBcm5hbGRvIENh
cnZhbGhvIGRlIE1lbG8gPGFjbWVAcmVkaGF0LmNvbT4KQ2M6IFJhbWt1bWFyIFJhbWFjaGFuZHJh
IDxhcnRhZ25vbkBnbWFpbC5jb20+ClNpZ25lZC1vZmYtYnk6IFJhbWt1bWFyIFJhbWFjaGFuZHJh
IDxhcnRhZ25vbkBnbWFpbC5jb20+Ci0tLQogdG9vbHMvcGVyZi9idWlsdGluLWxpc3QuYyB8IDgg
KysrKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0p
CgpkaWZmIC0tZ2l0IGEvdG9vbHMvcGVyZi9idWlsdGluLWxpc3QuYyBiL3Rvb2xzL3BlcmYvYnVp
bHRpbi1saXN0LmMKaW5kZXggMDExMTk1ZS4uMjYyOWMyNCAxMDA2NDQKLS0tIGEvdG9vbHMvcGVy
Zi9idWlsdGluLWxpc3QuYworKysgYi90b29scy9wZXJmL2J1aWx0aW4tbGlzdC5jCkBAIC0xOSw3
ICsxOSw5IEBACiBpbnQgY21kX2xpc3QoaW50IGFyZ2MsIGNvbnN0IGNoYXIgKiphcmd2LCBjb25z
dCBjaGFyICpwcmVmaXggX19tYXliZV91bnVzZWQpCiB7CiAJaW50IGk7CisJYm9vbCByYXdfZHVt
cCA9IGZhbHNlOwogCWNvbnN0IHN0cnVjdCBvcHRpb24gbGlzdF9vcHRpb25zW10gPSB7CisJCU9Q
VF9CT09MRUFOKDAsICJyYXctZHVtcCIsICZyYXdfZHVtcCwgInJhdyBkdW1wIGZvciBjb21wbGV0
aW9uIiksCiAJCU9QVF9FTkQoKQogCX07CiAJY29uc3QgY2hhciAqIGNvbnN0IGxpc3RfdXNhZ2Vb
XSA9IHsKQEAgLTMyLDYgKzM0LDEwIEBAIGludCBjbWRfbGlzdChpbnQgYXJnYywgY29uc3QgY2hh
ciAqKmFyZ3YsIGNvbnN0IGNoYXIgKnByZWZpeCBfX21heWJlX3VudXNlZCkKIAogCXNldHVwX3Bh
Z2VyKCk7CiAKKwlpZiAocmF3X2R1bXApIHsKKwkJcHJpbnRfZXZlbnRzKE5VTEwsIHRydWUpOwor
CQlyZXR1cm4gMDsKKwl9CiAJaWYgKGFyZ2MgPT0gMCkgewogCQlwcmludF9ldmVudHMoTlVMTCwg
ZmFsc2UpOwogCQlyZXR1cm4gMDsKQEAgLTUzLDggKzU5LDYgQEAgaW50IGNtZF9saXN0KGludCBh
cmdjLCBjb25zdCBjaGFyICoqYXJndiwgY29uc3QgY2hhciAqcHJlZml4IF9fbWF5YmVfdW51c2Vk
KQogCQkJcHJpbnRfaHdjYWNoZV9ldmVudHMoTlVMTCwgZmFsc2UpOwogCQllbHNlIGlmIChzdHJj
bXAoYXJndltpXSwgInBtdSIpID09IDApCiAJCQlwcmludF9wbXVfZXZlbnRzKE5VTEwsIGZhbHNl
KTsKLQkJZWxzZSBpZiAoc3RyY21wKGFyZ3ZbaV0sICItLXJhdy1kdW1wIikgPT0gMCkKLQkJCXBy
aW50X2V2ZW50cyhOVUxMLCB0cnVlKTsKIAkJZWxzZSB7CiAJCQljaGFyICpzZXAgPSBzdHJjaHIo
YXJndltpXSwgJzonKSwgKnM7CiAJCQlpbnQgc2VwX2lkeDsKLS0gCjEuOC41LjEuMTEzLmc4Y2I1
YmVmLmRpcnR5Cgo=
--089e0117689f28835404ed516198--
