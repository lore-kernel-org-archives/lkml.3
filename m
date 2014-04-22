Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaDVFyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 01:54:06 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:60660 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaDVFyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 01:54:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140422023410.GB1709@milliways>
References: <20140421203207.GA27025@milliways>
	<5549363.XIKIYZeGzc@grover>
	<20140422023106.GA1709@milliways>
	<20140422023410.GB1709@milliways>
Date: Tue, 22 Apr 2014 01:54:01 -0400
Message-ID: <CADnq5_OPQdict2MoUFDcLB0AXjkg9Np4W+U6O+RR8mExWKt-Rw@mail.gmail.com>
Subject: Re: 3.15.0-rc2 radeon HD 7480D [Aruba] blank display
From: Alex Deucher <alexdeucher@gmail.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: Ed Tomlinson <edt@aei.ca>, LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a11c123de2d0cc004f79b3ef7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c123de2d0cc004f79b3ef7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 21, 2014 at 10:34 PM, Ken Moffat <zarniwhoop@ntlworld.com> wrot=
e:
> On Tue, Apr 22, 2014 at 03:31:06AM +0100, Ken Moffat wrote:
>
> [ resending, somehow lkml dropped out of the Cc. ]
>
>> On Tue, Apr 22, 2014 at 12:19:40AM +0100, Ken Moffat wrote:
>> > On Mon, Apr 21, 2014 at 05:29:27PM -0400, Ed Tomlinson wrote:
>>
>> > > Ken,
>> > >
>> > > You might want to try reverting:
>> > >
>> > > commit 379dfc25e257ffe10eb53b86d2375f7c0f4f33ef
>> > > Author: Alex Deucher <alexdeucher@gmail.com>
>> > > Date:   Mon Apr 7 10:33:46 2014 -0400
>> > >
>> > >     drm/radeon/dp: switch to the common i2c over aux code
>> > >
>> > >     Provides a nice cleanup in radeon.
>> > >
>> > >     Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>> > >     Signed-off-by: Christian K=C3=B6nig <christian.koenig@amd.com>
>> > >
>> > > This fixed a similar problem here (see the drm pull thread for rc1)
>> > >
>> > > Thanks
>> > > Ed Tomlinson
>> >
>> >  Tried reverting that from rc2, but it didn't help.  Thanks anyway.
>> >
>>
>>  Well, I *believed* I had created a patch for that commit, and
>> reverted it from -rc2 with patch -R.  But I've now bisected through
>> drivers/gpu/drm between v3.14.0 and v3.15-rc2 and the bisection
>> pointed to that same commit, so I guess I did something wrong.
>>
>>  There were a couple of other issues along the way (mounting nfs
>> hung on one commit, startx hung on several of the commits, but I've
>> marked those as "good" because I had a display, even if the system
>> was not usable).
>>
>>  I've now gone back to linus' tree that I cloned a few hours ago,
>> i.e.
>> commit c089b229dfdd09d59a11d8bc2344bf8196d575ce
>> Merge: 9ac03675010a 0565103d1adb
>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>> Date:   Mon Apr 21 10:05:35 2014 -0700
>>
>>     Merge branch 'for-linus' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml
>>
>> created a branch, and *definitely* reverted
>> 379dfc25e257ffe10eb53b86d2375f7c0f4f33ef (using git revert) in that
>> branch.  And this version works fine.
>>
>>  So belatedly I see that I seem to have the same problem as Ed.  Or
>> at least that the same commit is causing both our problems.
>>
>>  Alex - do you need any more information from me to help with this ?

The attached patch should fix it.

Thanks,

Alex

--001a11c123de2d0cc004f79b3ef7
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-aux-fix-hpd-assignment-for-aux-bus.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-aux-fix-hpd-assignment-for-aux-bus.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_huas1mvw0

RnJvbSA5Y2Q3NjRmZDU3YmIyYTRlNWY2MThkMGY4YTY0YzgxNTRhODIwNjg4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5j
b20+CkRhdGU6IFR1ZSwgMjIgQXByIDIwMTQgMDE6NDk6MjggLTA0MDAKU3ViamVjdDogW1BBVENI
XSBkcm0vcmFkZW9uL2F1eDogZml4IGhwZCBhc3NpZ25tZW50IGZvciBhdXggYnVzCgpUaGUgaHBk
IChob3QgcGx1ZyBkZXRlY3QpIHBpbiBhc3NpZ25tZW50IGdvdCBsb3N0CmluIHRoZSBjb252ZXJz
aW9uIHRvIHRvIHRoZSBjb21tb24gaTJjIG92ZXIgYXV4CmNvZGUuICBXaXRob3V0IHRoaXMgaW5m
b3JtYXRpb24sIGF1eCB0cmFuc2FjdGlvbnMKZG8gbm90IHdvcmsgcHJvcGVybHkuICBGaXhlcyBE
UCBmYWlsdXJlcy4KClNpZ25lZC1vZmYtYnk6IEFsZXggRGV1Y2hlciA8YWxleGFuZGVyLmRldWNo
ZXJAYW1kLmNvbT4KLS0tCiBkcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2F0b21iaW9zX2RwLmMgfCAx
ICsKIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
Z3B1L2RybS9yYWRlb24vYXRvbWJpb3NfZHAuYyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRv
bWJpb3NfZHAuYwppbmRleCAxNTkzNjUyLi5iYzAxMTlmIDEwMDY0NAotLS0gYS9kcml2ZXJzL2dw
dS9kcm0vcmFkZW9uL2F0b21iaW9zX2RwLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9h
dG9tYmlvc19kcC5jCkBAIC0yMDksNiArMjA5LDcgQEAgdm9pZCByYWRlb25fZHBfYXV4X2luaXQo
c3RydWN0IHJhZGVvbl9jb25uZWN0b3IgKnJhZGVvbl9jb25uZWN0b3IpCiB7CiAJaW50IHJldDsK
IAorCXJhZGVvbl9jb25uZWN0b3ItPmRkY19idXMtPnJlYy5ocGQgPSByYWRlb25fY29ubmVjdG9y
LT5ocGQuaHBkOwogCXJhZGVvbl9jb25uZWN0b3ItPmRkY19idXMtPmF1eC5kZXYgPSByYWRlb25f
Y29ubmVjdG9yLT5iYXNlLmtkZXY7CiAJcmFkZW9uX2Nvbm5lY3Rvci0+ZGRjX2J1cy0+YXV4LnRy
YW5zZmVyID0gcmFkZW9uX2RwX2F1eF90cmFuc2ZlcjsKIAlyZXQgPSBkcm1fZHBfYXV4X3JlZ2lz
dGVyX2kyY19idXMoJnJhZGVvbl9jb25uZWN0b3ItPmRkY19idXMtPmF1eCk7Ci0tIAoxLjcuMTEu
NwoK
--001a11c123de2d0cc004f79b3ef7--
