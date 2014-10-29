Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647AbaJ2WZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 18:25:06 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:57235 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757611AbaJ2WZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:25:00 -0400
MIME-Version: 1.0
In-Reply-To: <CACE9dm9eFhA-JXjvuxKdO=4MMMMJ+ENiLTYxCrseeLAVi3xbKg@mail.gmail.com>
References: <alpine.LRH.2.11.1410291450290.28213@namei.org>
 <CALCETrUskFJY6hd9OCN_N1645VZ6zfwbGAuSEJNt6F_FPUi3gg@mail.gmail.com>
 <1414587599.5330.50.camel@dhcp-9-2-203-236.watson.ibm.com>
 <CALCETrWpHXp=7u2777ANJjxQ5rRqmutnEwf76dLX2s_LXf87pQ@mail.gmail.com>
 <20141029183612.GI6890@mwanda> <CALCETrU1S94M1L-UM5Rg91J4kGjJRFLiPxce5aAnPPJVeitQ_A@mail.gmail.com>
 <1414614013.5330.90.camel@dhcp-9-2-203-236.watson.ibm.com>
 <CALCETrUNYRbeA7EiTfd9hXMsHrES9EMAYaS=2FHOO=Kbm6qBTg@mail.gmail.com> <CACE9dm9eFhA-JXjvuxKdO=4MMMMJ+ENiLTYxCrseeLAVi3xbKg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 29 Oct 2014 15:24:38 -0700
Message-ID: <CALCETrWQT9T8bh6ycpzvt6C_xfce+BuMQe6hP+8JPJE_3OMqJQ@mail.gmail.com>
Subject: Re: [GIT PULL] Fix for Integrity subsystem null pointer deref
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <jmorris@namei.org>,
        "security@kernel.org" <security@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 3:23 PM, Dmitry Kasatkin
<dmitry.kasatkin@gmail.com> wrote:
> On 29 October 2014 23:22, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Oct 29, 2014 1:20 PM, "Mimi Zohar" <zohar@linux.vnet.ibm.com> wrote:
>>>
>>> On Wed, 2014-10-29 at 11:51 -0700, Andy Lutomirski wrote:
>>> > On Wed, Oct 29, 2014 at 11:36 AM, Dan Carpenter
>>> > <dan.carpenter@oracle.com> wrote:
>>> > > On Wed, Oct 29, 2014 at 09:23:45AM -0700, Andy Lutomirski wrote:
>>> > >> I have no idea what the semantics are.  All I'm saying is that it
>>> > >> looks like the code still accesses memory past the end of the buffer.
>>> > >> The buffer isn't a null pointer, so the symptom is different, but it
>>> > >> may still be a security bug.
>>> > >>
>>> > >> --Andy
>>> > >
>>> > > It only reads one byte into the struct "xattr_data->type" so checking
>>> > > for non-zero is sufficient and the patch is fine.
>>> >
>>> > Indeed.  Still... eww.  I don't like code that, upon local inspection,
>>> > is apparently wrong, even though it's coincidentally correct due to
>>> > some other far away condition.
>>>
>>> No, the code may be incomplete, but definitely not wrong.
>>
>> I said "apparently wrong" instead of "wrong" for a reason :)
>
> I see there is a long discussion about this patch.
>
> Actually using something like this "if (xattr_value_len <
> sizeof(struct evm_ima_xattr_data))" or using sizeof (struct
> signature_v2_hdr)
> in this function does not give too much.
> xattr value is variable length value and having that statement false
> absolutely does not mean that the value is correct.
> It can be even a random garbage of the correct size.
> This particular function checks the first byte only so the test is good enough.
>

My point is that there's no possible way to tell that only the first
byte is read just by reading the function.

--Andy

> - Dmitry
>
>>
>>>
>>> Mimi
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Thanks,
> Dmitry



-- 
Andy Lutomirski
AMA Capital Management, LLC
