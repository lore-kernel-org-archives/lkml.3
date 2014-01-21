Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbaAUSGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 13:06:15 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:64526 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971AbaAUSGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 13:06:12 -0500
MIME-Version: 1.0
In-Reply-To: <20140121171053.GD20798@arm.com>
References: <1388165112-6545-1-git-send-email-hjl.tools@gmail.com>
	<1388165112-6545-7-git-send-email-hjl.tools@gmail.com>
	<20140121171053.GD20798@arm.com>
Date: Tue, 21 Jan 2014 10:06:11 -0800
Message-ID: <CAMe9rOoKvJNkhHLwF+gfX1T8M=ekBvCJn7PJ61U9-_OvcB-tKQ@mail.gmail.com>
Subject: Re: [PATCH 6/8] Use __kernel_ulong_t in x86 struct semid64_ds
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7b2e3d000ef78d04f07eddcf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b2e3d000ef78d04f07eddcf
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Jan 21, 2014 at 9:10 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Fri, Dec 27, 2013 at 05:25:10PM +0000, H.J. Lu wrote:
>> Both x32 and x86-64 use the same struct semid64_ds for system calls.
>> But x32 long is 32-bit. This patch replaces unsigned long with
>> __kernel_ulong_t in x86 struct semid64_ds.
>>
>> Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
>> ---
>>  arch/x86/include/uapi/asm/sembuf.h | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/include/uapi/asm/sembuf.h b/arch/x86/include/uapi/asm/sembuf.h
>> index ee50c80..cc2d6a3 100644
>> --- a/arch/x86/include/uapi/asm/sembuf.h
>> +++ b/arch/x86/include/uapi/asm/sembuf.h
>> @@ -13,12 +13,12 @@
>>  struct semid64_ds {
>>       struct ipc64_perm sem_perm;     /* permissions .. see ipc.h */
>>       __kernel_time_t sem_otime;      /* last semop time */
>> -     unsigned long   __unused1;
>> +     __kernel_ulong_t __unused1;
>>       __kernel_time_t sem_ctime;      /* last change time */
>> -     unsigned long   __unused2;
>> -     unsigned long   sem_nsems;      /* no. of semaphores in array */
>> -     unsigned long   __unused3;
>> -     unsigned long   __unused4;
>> +     __kernel_ulong_t __unused2;
>> +     __kernel_ulong_t sem_nsems;     /* no. of semaphores in array */
>> +     __kernel_ulong_t __unused3;
>> +     __kernel_ulong_t __unused4;
>>  };
>
> Since you are at this, could you please change the
> include/uapi/asm-generic/sembuf.h structure as well?
>

I could, but my build doesn't use that header file.  I prefer not to
change something I can't test.

I am enclosing a program to check kernel uabi header files
against glibc header files.  You can try it on ILP32 ARM64.

-- 
H.J.

--047d7b2e3d000ef78d04f07eddcf
Content-Type: application/x-xz; name="uapi-header-check.tar.xz"
Content-Disposition: attachment; filename="uapi-header-check.tar.xz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hqph3hv60

/Td6WFoAAATm1rRGAgAhARYAAAB0L+Wj4Cf/BOZdADgYS3Zs2QpOuJqzz6GzBKslePyepc2iB6gh
axGgoHvhRRjELADnhpNcJ5pi35peiqkXz0/XYt3TNao4Mg3gIZxdDpiadj/OUgW/BIk/DGjl6Tal
Xq/xMBAUAszFJfCG5PZSIjWl44ujil0KWbMWbMmUlPHJK2OEmBa1cdHjJJMhGcEeOhm/3ZnZtQb4
HciX/Pm/wgjKx7CYDahSxnxmkHA0d7D99pzi9EfrgUmxgukyWG9RfNewmh/nWH261z6AbHmomysa
k0CrqNaL1SPmfF2cFs6MixShVz4ilUfbXub296sxB8j/gOBJkyTS82PAy74F0ZBmYT8Q1WYRFn21
eZ9hE/kpSXnmiiSKJ6VDCsYpQaVdqXhUY+4G2au89YlLtFRjZZIv9ph8tbasCENLGDl5Ditn+SzD
Q4Vup+zOpc2p9rntKn/NOAaXqcFaPmAUOwx9YfOuGC5rN9g9ArJgzEyEBjZze8YU51pIWjddAhVr
oi+Mr0HM3QOo+WRemt3p5BU9fXZh5oMzGhCY84H28vNfh+wk/iyIZjCKKtaM48Worcdsx35RrgGE
rOr0aERUYthMdnR9RVajQNcu/KwsunH3Cst6wI1FpZqD4FUIt6KQb0o7Cza6JQkIoEcBzUNolrPZ
nguBIhfvEIKsAuoadXb0N0ueai9vTQrops4o2+/h9Pk2vQAKyZOAI82Fl+ghpZgtXFMP3csslN6+
pdaLCNEetfupsTyDEMHhKaI3i9RsEhhMHFspVayUs5+HTLKSC+bjI/XLipeITLNbOi28O3m5lfhq
k66ekoADnIL5VEMM3yCYI2v+VRSvSsI5lTip1ncB0SH+7oEC3Ig+IokQvG2g0TF+dIfsfIXlq0u5
nrx+k2kiGleGxYEeHzK0Ld7UBaeONbhbEnDJQhcD4oLJ5RKbBuwZCXFdw+wEhpAtcPP6hwIIrglj
DrprbsCGwqYQTfejWo8DzrOVDZmLDup+pe+/mRFI681wWKnNzeTODg6p/rOEtWlT+WAzdotHHYbB
PKz+nKKa8hIRkdmcbevYLQIn/LVcB8fLgsEQtVIq3EYIT59oOtbu/Cqvmx5av0QYMT666P6b1Map
SnoQIPjdYaSvrjTOPsnvAkyUcfS0bpZl2ZxyizUn5BXdBIy62a4Gpt186wEgnZpuXXU2HPX23flL
hA5fOQ1omkdT2QKd46W/3wb2fMZfnkxfiEFBF27V2DkUw1u97VLO6mmmdQuTj0y2akZiY3RjlrwI
ccQXdxKsLkG1pLHP5KsnU5eHfLK4xZ45t1kD/cq4uqFyGTISslYJd/BHSF9uTvCXFSASAxPnBiHX
4d308vMtB4GP+iXEL6OALUloHzrUTsRvvgTXPwsJmB6Fco1MCEuyyWLRAEvUeAUQ7T2xh5RcvXwx
ZljZYGScHCnubyO8Kdk6zvelAb7i4QJvAaYWfOWwLV/+ElWEl2LAfusIVeXsQvEwHAs1DiJTbDB7
V1O2/rTfvCtQcDbJ8yXxSry9XkJGmlIHiz2h8LNROU61iOgCFXeEILkpI9xr5ZgETdwlSNaWxL4T
DHzrU8m+p77c/x7DkOAbK/K0vtFsV2nnUmtsYycLMU/NnSEfcebuxgZMBpEJoJl3gfu16vMraaHg
mM15lELt+K4V1JIJSVLuoEUJ4mXPP6xpsNKERJw6AAAAAAOAcy+h+5LHAAGCCoBQAAAk4XhbscRn
+wIAAAAABFla
--047d7b2e3d000ef78d04f07eddcf--
