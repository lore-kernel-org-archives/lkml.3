Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab3AWPUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:20:48 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:63482 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab3AWPUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:20:47 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAFTL4hwkRv5LjzXN2BmSxS73GqKZkJ=H92qaD+ohvdOs-pAxHg@mail.gmail.com>
References: <1358946905-13320-1-git-send-email-sedat.dilek@gmail.com>
	<CAHdPZaNYFBXMhvH7Jyy5Zy4MnB3iKfL9UW9xf3jy5MNBu8aPnw@mail.gmail.com>
	<CA+icZUW7XrOGguoPO00wxPLUr2Xc8fP=jQZwekpnmWKRewwX2g@mail.gmail.com>
	<CAFTL4hzcuxoy2deQpXDBRQZZBZ4VjT=EnO3ZZv6x-jGMTr_eaA@mail.gmail.com>
	<1358949189.21576.114.camel@gandalf.local.home>
	<CAFTL4hzSvnE-b=TEvKcT3Jpwh4ZLPsMotCC7etpUeDDFNYOQBQ@mail.gmail.com>
	<CA+icZUXM+tj5hnh--3CraRsvrsKfBUrS7Udf2L1OEhBnvWqpjQ@mail.gmail.com>
	<CAFTL4hwkRv5LjzXN2BmSxS73GqKZkJ=H92qaD+ohvdOs-pAxHg@mail.gmail.com>
Date: Wed, 23 Jan 2013 16:20:46 +0100
Message-ID: <CA+icZUVPDx=SkGFvYpACjoFE4NWchCJGs3ZnOVshs-a0dBYA3A@mail.gmail.com>
Subject: Re: [PATCH 3.8-rc4-nohz3] kvm: Add missing EXPORT_SYMBOL when CONFIG_KVM=m
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "devendra.aaru" <devendra.aaru@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=20cf30780bda12667a04d3f63da3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf30780bda12667a04d3f63da3
Content-Type: text/plain; charset=UTF-8

On Wed, Jan 23, 2013 at 4:03 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 2013/1/23 Sedat Dilek <sedat.dilek@gmail.com>:
>> On Wed, Jan 23, 2013 at 3:02 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>> 2013/1/23 Steven Rostedt <rostedt@goodmis.org>:
>>>> On Wed, 2013-01-23 at 14:46 +0100, Frederic Weisbecker wrote:
>>>>
>>>>> > Hmmm, yes, but why, clueless, CONFIG_KVM=y as a workaround!
>>>>>
>>>>> I believe he pointed out the "{i" to you. Typing mistake?
>>>>
>>>> In which case the CONFIG_KVM=y is a work around if that {i is within a
>>>> #ifndef CONFIG_KVM ;-)
>>>
>>> No it's in #ifdef CONFIG_KVM so the right fix is:
>>>
>>> diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
>>> index bbb2c2c..a13b8a3 100644
>>> --- a/kernel/context_tracking.c
>>> +++ b/kernel/context_tracking.c
>>> @@ -111,14 +111,19 @@ void guest_enter(void)
>>>         else
>>>                 __guest_enter();
>>>  }
>>> +EXPORT_SYMBOL_GPL(guest_enter);
>>>
>>>  void guest_exit(void)
>>>  {
>>> +#ifndef CONFIG_KVM
>>> +i
>>> +#endif
>>>         if (vtime_accounting_enabled())
>>>                 vtime_guest_exit(current);
>>>         else
>>>                 __guest_exit();
>>>  }
>>> +EXPORT_SYMBOL_GPL(guest_exit);
>>>  #endif
>>
>> So, what's the real fix for this issue?
>
> So CONFIG_SOMETHING doesn't work when it's a module. Hence we need to
> remove the ifdef CONFIG_KVM around guest_enter(), guest_exit(),
> vtime_guest_enter() and vtime_guest_exit(). Also it seems we need
> <linux/export.h> in context_tracking.c

You mean sth. like this?

- Sedat -

--20cf30780bda12667a04d3f63da3
Content-Type: application/octet-stream; 
	name="kvm-Fix-missing-EXPORT_SYMBOL_GPL.diff"
Content-Disposition: attachment; 
	filename="kvm-Fix-missing-EXPORT_SYMBOL_GPL.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hcame08z0

ZGlmZiAtLWdpdCBhL2tlcm5lbC9jb250ZXh0X3RyYWNraW5nLmMgYi9rZXJuZWwvY29udGV4dF90
cmFja2luZy5jCmluZGV4IGJiYjJjMmMuLjg4MDJhNjYgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9jb250
ZXh0X3RyYWNraW5nLmMKKysrIGIva2VybmVsL2NvbnRleHRfdHJhY2tpbmcuYwpAQCAtMTksNyAr
MTksNyBAQAogI2luY2x1ZGUgPGxpbnV4L3JjdXBkYXRlLmg+CiAjaW5jbHVkZSA8bGludXgvc2No
ZWQuaD4KICNpbmNsdWRlIDxsaW51eC9oYXJkaXJxLmg+Ci0KKyNpbmNsdWRlIDxsaW51eC9leHBv
cnQuaD4KIAogREVGSU5FX1BFUl9DUFUoc3RydWN0IGNvbnRleHRfdHJhY2tpbmcsIGNvbnRleHRf
dHJhY2tpbmcpID0gewogI2lmZGVmIENPTkZJR19DT05URVhUX1RSQUNLSU5HX0ZPUkNFCkBAIC0x
MDMsNyArMTAzLDYgQEAgdm9pZCB1c2VyX2V4aXQodm9pZCkKIAlsb2NhbF9pcnFfcmVzdG9yZShm
bGFncyk7CiB9CiAKLSNpZmRlZiBDT05GSUdfS1ZNCiB2b2lkIGd1ZXN0X2VudGVyKHZvaWQpCiB7
CiAJaWYgKHZ0aW1lX2FjY291bnRpbmdfZW5hYmxlZCgpKQpAQCAtMTExLDYgKzExMCw3IEBAIHZv
aWQgZ3Vlc3RfZW50ZXIodm9pZCkKIAllbHNlCiAJCV9fZ3Vlc3RfZW50ZXIoKTsKIH0KK0VYUE9S
VF9TWU1CT0xfR1BMKGd1ZXN0X2VudGVyKTsKIAogdm9pZCBndWVzdF9leGl0KHZvaWQpCiB7CkBA
IC0xMTksOCArMTE5LDcgQEAgdm9pZCBndWVzdF9leGl0KHZvaWQpCiAJZWxzZQogCQlfX2d1ZXN0
X2V4aXQoKTsKIH0KLSNlbmRpZgotCitFWFBPUlRfU1lNQk9MX0dQTChndWVzdF9leGl0KTsKIAog
LyoqCiAgKiBjb250ZXh0X3RyYWNraW5nX3Rhc2tfc3dpdGNoIC0gY29udGV4dCBzd2l0Y2ggdGhl
IHN5c2NhbGwgY2FsbGJhY2tzCmRpZmYgLS1naXQgYS9rZXJuZWwvc2NoZWQvY3B1dGltZS5jIGIv
a2VybmVsL3NjaGVkL2NwdXRpbWUuYwppbmRleCA1NTAwYTgxLi5kYzY2Y2JhIDEwMDY0NAotLS0g
YS9rZXJuZWwvc2NoZWQvY3B1dGltZS5jCisrKyBiL2tlcm5lbC9zY2hlZC9jcHV0aW1lLmMKQEAg
LTY3Nyw3ICs2NzcsNiBAQCB2b2lkIHZ0aW1lX3VzZXJfZW50ZXIoc3RydWN0IHRhc2tfc3RydWN0
ICp0c2spCiAJd3JpdGVfc2VxdW5sb2NrKCZ0c2stPnZ0aW1lX3NlcWxvY2spOwogfQogCi0jaWZk
ZWYgQ09ORklHX0tWTQogdm9pZCB2dGltZV9ndWVzdF9lbnRlcihzdHJ1Y3QgdGFza19zdHJ1Y3Qg
KnRzaykKIHsKIAl3cml0ZV9zZXFsb2NrKCZ0c2stPnZ0aW1lX3NlcWxvY2spOwpAQCAtNjg1LDYg
KzY4NCw3IEBAIHZvaWQgdnRpbWVfZ3Vlc3RfZW50ZXIoc3RydWN0IHRhc2tfc3RydWN0ICp0c2sp
CiAJY3VycmVudC0+ZmxhZ3MgfD0gUEZfVkNQVTsKIAl3cml0ZV9zZXF1bmxvY2soJnRzay0+dnRp
bWVfc2VxbG9jayk7CiB9CitFWFBPUlRfU1lNQk9MX0dQTCh2dGltZV9ndWVzdF9lbnRlcik7CiAK
IHZvaWQgdnRpbWVfZ3Vlc3RfZXhpdChzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRzaykKIHsKQEAgLTY5
Myw3ICs2OTMsNyBAQCB2b2lkIHZ0aW1lX2d1ZXN0X2V4aXQoc3RydWN0IHRhc2tfc3RydWN0ICp0
c2spCiAJY3VycmVudC0+ZmxhZ3MgJj0gflBGX1ZDUFU7CiAJd3JpdGVfc2VxdW5sb2NrKCZ0c2st
PnZ0aW1lX3NlcWxvY2spOwogfQotI2VuZGlmCitFWFBPUlRfU1lNQk9MX0dQTCh2dGltZV9ndWVz
dF9leGl0KTsKIAogdm9pZCB2dGltZV9hY2NvdW50X2lkbGUoc3RydWN0IHRhc2tfc3RydWN0ICp0
c2spCiB7Cg==
--20cf30780bda12667a04d3f63da3--
