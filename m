Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759763Ab3ICJUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 05:20:06 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59156 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab3ICJUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 05:20:04 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUUEk68pkANi9Yn4GV5RrLZ=cdhHe8YaMdB8yauDAp7OXg@mail.gmail.com>
References: <1377875916-5208-1-git-send-email-sedat.dilek@gmail.com>
	<20130830164905.GA31061@rric.localhost>
	<874na2uw7t.fsf@sejong.aot.lge.com>
	<CA+icZUX-a2wOFDCntwJag5203UiaiAMntO+TqG7upejZ3uiVQQ@mail.gmail.com>
	<CA+icZUUEk68pkANi9Yn4GV5RrLZ=cdhHe8YaMdB8yauDAp7OXg@mail.gmail.com>
Date: Tue, 3 Sep 2013 11:20:02 +0200
Message-ID: <CA+icZUVjWynPfHSuv+xS14YhBv0xFmzsVZczYYWn-UOdKro=pQ@mail.gmail.com>
Subject: Re: [PATCH] tools: perf: Fix liblk not built when using perf_install target
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Robert Richter <rric@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: multipart/mixed; boundary=089e01419fbe9c55a204e5773145
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e01419fbe9c55a204e5773145
Content-Type: text/plain; charset=UTF-8

On Tue, Sep 3, 2013 at 11:13 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Tue, Sep 3, 2013 at 10:56 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Tue, Sep 3, 2013 at 10:48 AM, Namhyung Kim <namhyung@kernel.org> wrote:
>>> Hi,
>>>
>>> On Fri, 30 Aug 2013 18:49:05 +0200, Robert Richter wrote:
>>>> On 30.08.13 17:18:36, Sedat Dilek wrote:
>>>>> So, I tried to build perf the "official" way:
>>>>>
>>>>>    $ make -C tools/ perf_install
>>>>>
>>>>> Unfortunately, my build breaks like this:
>>>>> ...
>>>>> make[2]: Entering directory
>>>>> `~/src/linux-kernel/linux/tools/lib/traceevent'
>>>>> make[2]: Leaving directory
>>>>> `~/src/linux-kernel/linux/tools/lib/traceevent'
>>>>>     LINK perf
>>>>> gcc: error: ~/src/linux-kernel/linux/tools/lib/lk/liblk.a: No such file or directory
>>>>> make[1]: *** [perf] Error 1
>>>>> make[1]: Leaving directory `~/src/linux-kernel/linux/tools/perf'
>>>>> make: *** [perf_install] Error 2
>>>>>
>>>>> After some discussion on IRC with peterz and acme and a closer look at
>>>>> the targets in "tools/Makefile", I have noticed that the perf_install
>>>>> target misses liblk to be built beforehand.
>>>>
>>>> There are no build prerequisites on purpose for install targets.
>>>> Install targets are intended to be run with root permissions. We don't
>>>> want to create/overwrite files in the build directory as root while
>>>> running install rules. Thus, you always need to run:
>>>>
>>>>  $ make -C tools/ perf
>>>>
>>>> or similar first.
>>>
>>> But AFAIK install target usually depends on build targets on many
>>> projects.  And perf too already does the same:
>>>
>>>   [ tools/perf/Makefile ]
>>>   install-bin: all
>>>         ...
>>>
>>>   install: install-bin
>>>
>>>
>>> So if you really concern the permission problem, install target should
>>> not build perf itself, right?  But in this case, it tried to build perf
>>> but failed to do it on liblk.
>>>
>>>>
>>>>> On the contrary the perf_clean target invokes to clean liblk when perf
>>>>> is cleaned.
>>>>>
>>>>> [ tools/Makefile ]
>>>>> ...
>>>>> perf_clean: liblk_clean
>>>>>      $(call descend,$(@:_clean=),clean)
>>>>> ...
>>>>>
>>>>> Fix this by adding liblk target to perf_install target.
>>>>
>>>> So no, this is not the proper fix.
>>>>
>>>> Before installing you *need* to build. You might want to fix the
>>>> documenation...
>>>
>>> Hmm.. I don't know.  What I'm curious about is why it didn't build liblk
>>> during building perf.
>>>
>>
>> The day I fell over that perf stuff, I created a pile of patches
>> fixing that unbeloved tools stuff.
>> Some tools listed in tools/Makefile are not buildable via...
>>
>>      $ make -C tools/ <tool>
>>      $ make -C tools/ <tool>_install
>>
>> ...because some <tool> have no "install" target.
>>
>> I attach the patchset here. It has no "proper" changelogs.
>> The series is "incomplete"... needs some more love... eat it carefully.
>>
>
> Attached 0008 v2.
>
> * move cpupower to tools where sources are below power-dir.
> * selftests is always last target
>

Grrr, space/tabs :-(.

0008 v3 attached.

- Sedat -

--089e01419fbe9c55a204e5773145
Content-Type: application/octet-stream; 
	name="0008-tools-Reorder-tool-_install-install-and-clean-target.patch"
Content-Disposition: attachment; 
	filename="0008-tools-Reorder-tool-_install-install-and-clean-target.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hl4woqjs1

RnJvbSBiMDU5NWIzZDhiZTUxM2MwM2E4YzQ2Mzg0YzY1OTRjNjg4NmQ5YWRkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBUdWUsIDMgU2VwIDIwMTMgMTE6MTg6NTQgKzAyMDAKU3ViamVjdDogW1BBVENIIDgvOF0g
dG9vbHM6IFJlb3JkZXIgPHRvb2w+X2luc3RhbGwsIGluc3RhbGwgYW5kIGNsZWFuIHRhcmdldHMK
ICh2MykKClNpZ25lZC1vZmYtYnk6IFNlZGF0IERpbGVrIDxzZWRhdC5kaWxla0BnbWFpbC5jb20+
Ci0tLQogdG9vbHMvTWFrZWZpbGUgfCA0OCArKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAyNSBpbnNlcnRpb25zKCspLCAyMyBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS90b29scy9NYWtlZmlsZSBiL3Rvb2xzL01ha2VmaWxl
CmluZGV4IDgyMzhlNWYuLmVlMDA0MDAgMTAwNjQ0Ci0tLSBhL3Rvb2xzL01ha2VmaWxlCisrKyBi
L3Rvb2xzL01ha2VmaWxlCkBAIC0zNCwxMCArMzQsNyBAQCBoZWxwOgogCUBlY2hvICcgICAgdGhl
IHJlc3BlY3RpdmUgYnVpbGQgZGlyZWN0b3J5LicKIAlAZWNobyAnICBjbGVhbjogYSBzdW1tYXJ5
IGNsZWFuIHRhcmdldCB0byBjbGVhbiBfYWxsXyBmb2xkZXJzJwogCi1jcHVwb3dlcjogRk9SQ0UK
LQkkKGNhbGwgZGVzY2VuZCxwb3dlci8kQCkKLQotY2dyb3VwIGZpcmV3aXJlIGxndWVzdCB1c2Ig
dmlydGlvIG5ldDogRk9SQ0UKK2Nncm91cCBmaXJld2lyZSBsZ3Vlc3QgbmV0IHVzYiB2aXJ0aW86
IEZPUkNFCiAJJChjYWxsIGRlc2NlbmQsJEApCiAKIGxpYmxrOiBGT1JDRQpAQCAtNDYsMzQgKzQz
LDM1IEBAIGxpYmxrOiBGT1JDRQogcGVyZiB2bTogbGlibGsgRk9SQ0UKIAkkKGNhbGwgZGVzY2Vu
ZCwkQCkKIAotc2VsZnRlc3RzOiBGT1JDRQotCSQoY2FsbCBkZXNjZW5kLHRlc3RpbmcvJEApCitj
cHVwb3dlcjogRk9SQ0UKKyAgICAgICAgJChjYWxsIGRlc2NlbmQscG93ZXIvJEApCiAKIHR1cmJv
c3RhdCB4ODZfZW5lcmd5X3BlcmZfcG9saWN5OiBGT1JDRQogCSQoY2FsbCBkZXNjZW5kLHBvd2Vy
L3g4Ni8kQCkKIAotYWxsOiBjcHVwb3dlciBjZ3JvdXAgZmlyZXdpcmUgbGd1ZXN0IG5ldCB1c2Ig
dmlydGlvIHBlcmYgdm0gc2VsZnRlc3RzIHR1cmJvc3RhdCB4ODZfZW5lcmd5X3BlcmZfcG9saWN5
CitzZWxmdGVzdHM6IEZPUkNFCisgICAgICAgICQoY2FsbCBkZXNjZW5kLHRlc3RpbmcvJEApCiAK
LWNwdXBvd2VyX2luc3RhbGw6Ci0JJChjYWxsIGRlc2NlbmQscG93ZXIvJChAOl9pbnN0YWxsPSks
aW5zdGFsbCkKK2FsbDogY2dyb3VwIGZpcmV3aXJlIGxndWVzdCBuZXQgdXNiIHZpcnRpbyBwZXJm
IHZtIGNwdXBvd2VyIHR1cmJvc3RhdCB4ODZfZW5lcmd5X3BlcmZfcG9saWN5IHNlbGZ0ZXN0cwog
Ci1jZ3JvdXBfaW5zdGFsbCBmaXJld2lyZV9pbnN0YWxsIGxndWVzdF9pbnN0YWxsIHBlcmZfaW5z
dGFsbCB1c2JfaW5zdGFsbCB2aXJ0aW9faW5zdGFsbCB2bV9pbnN0YWxsIG5ldF9pbnN0YWxsOgor
Y2dyb3VwX2luc3RhbGwgZmlyZXdpcmVfaW5zdGFsbCBsZ3Vlc3RfaW5zdGFsbCBuZXRfaW5zdGFs
bCB1c2JfaW5zdGFsbCB2aXJ0aW9faW5zdGFsbCBwZXJmX2luc3RhbGwgdm1faW5zdGFsbDoKIAkk
KGNhbGwgZGVzY2VuZCwkKEA6X2luc3RhbGw9KSxpbnN0YWxsKQogCi1zZWxmdGVzdHNfaW5zdGFs
bDoKLQkkKGNhbGwgZGVzY2VuZCx0ZXN0aW5nLyQoQDpfaW5zdGFsbD0pLGluc3RhbGwpCitjcHVw
b3dlcl9pbnN0YWxsOgorCSQoY2FsbCBkZXNjZW5kLHBvd2VyLyQoQDpfaW5zdGFsbD0pLGluc3Rh
bGwpCiAKIHR1cmJvc3RhdF9pbnN0YWxsIHg4Nl9lbmVyZ3lfcGVyZl9wb2xpY3lfaW5zdGFsbDoK
IAkkKGNhbGwgZGVzY2VuZCxwb3dlci94ODYvJChAOl9pbnN0YWxsPSksaW5zdGFsbCkKIAotaW5z
dGFsbDogY2dyb3VwX2luc3RhbGwgY3B1cG93ZXJfaW5zdGFsbCBmaXJld2lyZV9pbnN0YWxsIGxn
dWVzdF9pbnN0YWxsIFwKLQkJcGVyZl9pbnN0YWxsIHNlbGZ0ZXN0c19pbnN0YWxsIHR1cmJvc3Rh
dF9pbnN0YWxsIHVzYl9pbnN0YWxsIFwKLQkJdmlydGlvX2luc3RhbGwgdm1faW5zdGFsbCBuZXRf
aW5zdGFsbCB4ODZfZW5lcmd5X3BlcmZfcG9saWN5X2luc3RhbGwKK3NlbGZ0ZXN0c19pbnN0YWxs
OgorCSQoY2FsbCBkZXNjZW5kLHRlc3RpbmcvJChAOl9pbnN0YWxsPSksaW5zdGFsbCkKIAotY3B1
cG93ZXJfY2xlYW46Ci0JJChjYWxsIGRlc2NlbmQscG93ZXIvY3B1cG93ZXIsY2xlYW4pCitpbnN0
YWxsOiBjZ3JvdXBfaW5zdGFsbCBmaXJld2lyZV9pbnN0YWxsIGxndWVzdF9pbnN0YWxsIG5ldF9p
bnN0YWxsIHVzYl9pbnN0YWxsIHZpcnRpb19pbnN0YWxsIFwKKyAgICAgICAgICAgICAgIHBlcmZf
aW5zdGFsbCB2bV9pbnN0YWxsIFwKKyAgICAgICAgICAgICAgIGNwdXBvd2VyX2luc3RhbGwgdHVy
Ym9zdGF0X2luc3RhbGwgeDg2X2VuZXJneV9wZXJmX3BvbGljeV9pbnN0YWxsIFwKKyAgICAgICAg
ICAgICAgIHNlbGZ0ZXN0c19pbnN0YWxsCiAKLWNncm91cF9jbGVhbiBmaXJld2lyZV9jbGVhbiBs
Z3Vlc3RfY2xlYW4gdXNiX2NsZWFuIHZpcnRpb19jbGVhbiBuZXRfY2xlYW46CitjZ3JvdXBfY2xl
YW4gZmlyZXdpcmVfY2xlYW4gbGd1ZXN0X2NsZWFuIG5ldF9jbGVhbiB1c2JfY2xlYW4gdmlydGlv
X2NsZWFuOgogCSQoY2FsbCBkZXNjZW5kLCQoQDpfY2xlYW49KSxjbGVhbikKIAogbGlibGtfY2xl
YW46CkBAIC04MiwxNCArODAsMTggQEAgbGlibGtfY2xlYW46CiBwZXJmX2NsZWFuIHZtX2NsZWFu
OiBsaWJsa19jbGVhbgogCSQoY2FsbCBkZXNjZW5kLCQoQDpfY2xlYW49KSxjbGVhbikKIAotc2Vs
ZnRlc3RzX2NsZWFuOgotCSQoY2FsbCBkZXNjZW5kLHRlc3RpbmcvJChAOl9jbGVhbj0pLGNsZWFu
KQorY3B1cG93ZXJfY2xlYW46CisJJChjYWxsIGRlc2NlbmQscG93ZXIvY3B1cG93ZXIsY2xlYW4p
CiAKIHR1cmJvc3RhdF9jbGVhbiB4ODZfZW5lcmd5X3BlcmZfcG9saWN5X2NsZWFuOgogCSQoY2Fs
bCBkZXNjZW5kLHBvd2VyL3g4Ni8kKEA6X2NsZWFuPSksY2xlYW4pCiAKLWNsZWFuOiBjZ3JvdXBf
Y2xlYW4gY3B1cG93ZXJfY2xlYW4gZmlyZXdpcmVfY2xlYW4gbGd1ZXN0X2NsZWFuIHBlcmZfY2xl
YW4gXAotCQlzZWxmdGVzdHNfY2xlYW4gdHVyYm9zdGF0X2NsZWFuIHVzYl9jbGVhbiB2aXJ0aW9f
Y2xlYW4gXAotCQl2bV9jbGVhbiBuZXRfY2xlYW4geDg2X2VuZXJneV9wZXJmX3BvbGljeV9jbGVh
bgorc2VsZnRlc3RzX2NsZWFuOgorCSQoY2FsbCBkZXNjZW5kLHRlc3RpbmcvJChAOl9jbGVhbj0p
LGNsZWFuKQorCitjbGVhbjogY2dyb3VwX2NsZWFuIGZpcmV3aXJlX2NsZWFuIGxndWVzdF9jbGVh
biBuZXRfY2xlYW4gdXNiX2NsZWFuIHZpcnRpb19jbGVhbiBcCisgICAgICAgICAgICAgICBwZXJm
X2NsZWFuIHZtX2NsZWFuIFwKKyAgICAgICAgICAgICAgIGNwdXBvd2VyX2NsZWFuIHR1cmJvc3Rh
dF9jbGVhbiB4ODZfZW5lcmd5X3BlcmZfcG9saWN5X2NsZWFuIFwKKyAgICAgICAgICAgICAgIHNl
bGZ0ZXN0c19jbGVhbgogCiAuUEhPTlk6IEZPUkNFCi0tIAoxLjguNAoK
--089e01419fbe9c55a204e5773145--
