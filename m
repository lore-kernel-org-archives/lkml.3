Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759662Ab3ICJNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 05:13:55 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:55474 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab3ICJNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 05:13:54 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUX-a2wOFDCntwJag5203UiaiAMntO+TqG7upejZ3uiVQQ@mail.gmail.com>
References: <1377875916-5208-1-git-send-email-sedat.dilek@gmail.com>
	<20130830164905.GA31061@rric.localhost>
	<874na2uw7t.fsf@sejong.aot.lge.com>
	<CA+icZUX-a2wOFDCntwJag5203UiaiAMntO+TqG7upejZ3uiVQQ@mail.gmail.com>
Date: Tue, 3 Sep 2013 11:13:52 +0200
Message-ID: <CA+icZUUEk68pkANi9Yn4GV5RrLZ=cdhHe8YaMdB8yauDAp7OXg@mail.gmail.com>
Subject: Re: [PATCH] tools: perf: Fix liblk not built when using perf_install target
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Robert Richter <rric@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: multipart/mixed; boundary=f46d043c7c5689353104e5771b92
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d043c7c5689353104e5771b92
Content-Type: text/plain; charset=UTF-8

On Tue, Sep 3, 2013 at 10:56 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Tue, Sep 3, 2013 at 10:48 AM, Namhyung Kim <namhyung@kernel.org> wrote:
>> Hi,
>>
>> On Fri, 30 Aug 2013 18:49:05 +0200, Robert Richter wrote:
>>> On 30.08.13 17:18:36, Sedat Dilek wrote:
>>>> So, I tried to build perf the "official" way:
>>>>
>>>>    $ make -C tools/ perf_install
>>>>
>>>> Unfortunately, my build breaks like this:
>>>> ...
>>>> make[2]: Entering directory
>>>> `~/src/linux-kernel/linux/tools/lib/traceevent'
>>>> make[2]: Leaving directory
>>>> `~/src/linux-kernel/linux/tools/lib/traceevent'
>>>>     LINK perf
>>>> gcc: error: ~/src/linux-kernel/linux/tools/lib/lk/liblk.a: No such file or directory
>>>> make[1]: *** [perf] Error 1
>>>> make[1]: Leaving directory `~/src/linux-kernel/linux/tools/perf'
>>>> make: *** [perf_install] Error 2
>>>>
>>>> After some discussion on IRC with peterz and acme and a closer look at
>>>> the targets in "tools/Makefile", I have noticed that the perf_install
>>>> target misses liblk to be built beforehand.
>>>
>>> There are no build prerequisites on purpose for install targets.
>>> Install targets are intended to be run with root permissions. We don't
>>> want to create/overwrite files in the build directory as root while
>>> running install rules. Thus, you always need to run:
>>>
>>>  $ make -C tools/ perf
>>>
>>> or similar first.
>>
>> But AFAIK install target usually depends on build targets on many
>> projects.  And perf too already does the same:
>>
>>   [ tools/perf/Makefile ]
>>   install-bin: all
>>         ...
>>
>>   install: install-bin
>>
>>
>> So if you really concern the permission problem, install target should
>> not build perf itself, right?  But in this case, it tried to build perf
>> but failed to do it on liblk.
>>
>>>
>>>> On the contrary the perf_clean target invokes to clean liblk when perf
>>>> is cleaned.
>>>>
>>>> [ tools/Makefile ]
>>>> ...
>>>> perf_clean: liblk_clean
>>>>      $(call descend,$(@:_clean=),clean)
>>>> ...
>>>>
>>>> Fix this by adding liblk target to perf_install target.
>>>
>>> So no, this is not the proper fix.
>>>
>>> Before installing you *need* to build. You might want to fix the
>>> documenation...
>>
>> Hmm.. I don't know.  What I'm curious about is why it didn't build liblk
>> during building perf.
>>
>
> The day I fell over that perf stuff, I created a pile of patches
> fixing that unbeloved tools stuff.
> Some tools listed in tools/Makefile are not buildable via...
>
>      $ make -C tools/ <tool>
>      $ make -C tools/ <tool>_install
>
> ...because some <tool> have no "install" target.
>
> I attach the patchset here. It has no "proper" changelogs.
> The series is "incomplete"... needs some more love... eat it carefully.
>

Attached 0008 v2.

* move cpupower to tools where sources are below power-dir.
* selftests is always last target

- Sedat -

--f46d043c7c5689353104e5771b92
Content-Type: application/octet-stream; 
	name="0008-tools-Reorder-tool-_install-install-and-clean-target.patch"
Content-Disposition: attachment; 
	filename="0008-tools-Reorder-tool-_install-install-and-clean-target.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hl4wh29v8

RnJvbSBkZmVmMjg4N2YwODRkMmNjZjdlMzdmNmIzMTkyNTRjM2I3M2NiZTY1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBUdWUsIDMgU2VwIDIwMTMgMTE6MDk6NDMgKzAyMDAKU3ViamVjdDogW1BBVENIIDgvOF0g
dG9vbHM6IFJlb3JkZXIgPHRvb2w+X2luc3RhbGwsIGluc3RhbGwgYW5kIGNsZWFuIHRhcmdldHMK
ICh2MikKClNpZ25lZC1vZmYtYnk6IFNlZGF0IERpbGVrIDxzZWRhdC5kaWxla0BnbWFpbC5jb20+
Ci0tLQogdG9vbHMvTWFrZWZpbGUgfCA0OCArKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAyNSBpbnNlcnRpb25zKCspLCAyMyBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS90b29scy9NYWtlZmlsZSBiL3Rvb2xzL01ha2VmaWxl
CmluZGV4IDgyMzhlNWYuLjU1NjY4MjkgMTAwNjQ0Ci0tLSBhL3Rvb2xzL01ha2VmaWxlCisrKyBi
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
b3dlcl9pbnN0YWxsOgorICAgICAgICAkKGNhbGwgZGVzY2VuZCxwb3dlci8kKEA6X2luc3RhbGw9
KSxpbnN0YWxsKQogCiB0dXJib3N0YXRfaW5zdGFsbCB4ODZfZW5lcmd5X3BlcmZfcG9saWN5X2lu
c3RhbGw6CiAJJChjYWxsIGRlc2NlbmQscG93ZXIveDg2LyQoQDpfaW5zdGFsbD0pLGluc3RhbGwp
CiAKLWluc3RhbGw6IGNncm91cF9pbnN0YWxsIGNwdXBvd2VyX2luc3RhbGwgZmlyZXdpcmVfaW5z
dGFsbCBsZ3Vlc3RfaW5zdGFsbCBcCi0JCXBlcmZfaW5zdGFsbCBzZWxmdGVzdHNfaW5zdGFsbCB0
dXJib3N0YXRfaW5zdGFsbCB1c2JfaW5zdGFsbCBcCi0JCXZpcnRpb19pbnN0YWxsIHZtX2luc3Rh
bGwgbmV0X2luc3RhbGwgeDg2X2VuZXJneV9wZXJmX3BvbGljeV9pbnN0YWxsCitzZWxmdGVzdHNf
aW5zdGFsbDoKKyAgICAgICAgJChjYWxsIGRlc2NlbmQsdGVzdGluZy8kKEA6X2luc3RhbGw9KSxp
bnN0YWxsKQogCi1jcHVwb3dlcl9jbGVhbjoKLQkkKGNhbGwgZGVzY2VuZCxwb3dlci9jcHVwb3dl
cixjbGVhbikKK2luc3RhbGw6IGNncm91cF9pbnN0YWxsIGZpcmV3aXJlX2luc3RhbGwgbGd1ZXN0
X2luc3RhbGwgbmV0X2luc3RhbGwgdXNiX2luc3RhbGwgdmlydGlvX2luc3RhbGwgXAorICAgICAg
ICAgICAgICAgcGVyZl9pbnN0YWxsIHZtX2luc3RhbGwgXAorICAgICAgICAgICAgICAgY3B1cG93
ZXJfaW5zdGFsbCB0dXJib3N0YXRfaW5zdGFsbCB4ODZfZW5lcmd5X3BlcmZfcG9saWN5X2luc3Rh
bGwgXAorICAgICAgICAgICAgICAgc2VsZnRlc3RzX2luc3RhbGwKIAotY2dyb3VwX2NsZWFuIGZp
cmV3aXJlX2NsZWFuIGxndWVzdF9jbGVhbiB1c2JfY2xlYW4gdmlydGlvX2NsZWFuIG5ldF9jbGVh
bjoKK2Nncm91cF9jbGVhbiBmaXJld2lyZV9jbGVhbiBsZ3Vlc3RfY2xlYW4gbmV0X2NsZWFuIHVz
Yl9jbGVhbiB2aXJ0aW9fY2xlYW46CiAJJChjYWxsIGRlc2NlbmQsJChAOl9jbGVhbj0pLGNsZWFu
KQogCiBsaWJsa19jbGVhbjoKQEAgLTgyLDE0ICs4MCwxOCBAQCBsaWJsa19jbGVhbjoKIHBlcmZf
Y2xlYW4gdm1fY2xlYW46IGxpYmxrX2NsZWFuCiAJJChjYWxsIGRlc2NlbmQsJChAOl9jbGVhbj0p
LGNsZWFuKQogCi1zZWxmdGVzdHNfY2xlYW46Ci0JJChjYWxsIGRlc2NlbmQsdGVzdGluZy8kKEA6
X2NsZWFuPSksY2xlYW4pCitjcHVwb3dlcl9jbGVhbjoKKyAgICAgICAgJChjYWxsIGRlc2NlbmQs
cG93ZXIvY3B1cG93ZXIsY2xlYW4pCiAKIHR1cmJvc3RhdF9jbGVhbiB4ODZfZW5lcmd5X3BlcmZf
cG9saWN5X2NsZWFuOgogCSQoY2FsbCBkZXNjZW5kLHBvd2VyL3g4Ni8kKEA6X2NsZWFuPSksY2xl
YW4pCiAKLWNsZWFuOiBjZ3JvdXBfY2xlYW4gY3B1cG93ZXJfY2xlYW4gZmlyZXdpcmVfY2xlYW4g
bGd1ZXN0X2NsZWFuIHBlcmZfY2xlYW4gXAotCQlzZWxmdGVzdHNfY2xlYW4gdHVyYm9zdGF0X2Ns
ZWFuIHVzYl9jbGVhbiB2aXJ0aW9fY2xlYW4gXAotCQl2bV9jbGVhbiBuZXRfY2xlYW4geDg2X2Vu
ZXJneV9wZXJmX3BvbGljeV9jbGVhbgorc2VsZnRlc3RzX2NsZWFuOgorICAgICAgICAkKGNhbGwg
ZGVzY2VuZCx0ZXN0aW5nLyQoQDpfY2xlYW49KSxjbGVhbikKKworY2xlYW46IGNncm91cF9jbGVh
biBmaXJld2lyZV9jbGVhbiBsZ3Vlc3RfY2xlYW4gbmV0X2NsZWFuIHVzYl9jbGVhbiB2aXJ0aW9f
Y2xlYW4gXAorICAgICAgICAgICAgICAgcGVyZl9jbGVhbiB2bV9jbGVhbiBcCisgICAgICAgICAg
ICAgICBjcHVwb3dlcl9jbGVhbiB0dXJib3N0YXRfY2xlYW4geDg2X2VuZXJneV9wZXJmX3BvbGlj
eV9jbGVhbiBcCisgICAgICAgICAgICAgICBzZWxmdGVzdHNfY2xlYW4KIAogLlBIT05ZOiBGT1JD
RQotLSAKMS44LjQKCg==
--f46d043c7c5689353104e5771b92--
