Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572Ab3BYMZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 07:25:08 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:52179 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab3BYMZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 07:25:05 -0500
MIME-Version: 1.0
In-Reply-To: <20130214200557.GF16671@redhat.com>
References: <959cfd74266e82f72e5879c6c8b798d76f6cad31.1360746454.git.dmitry.kasatkin@intel.com>
	<20130214200557.GF16671@redhat.com>
Date: Mon, 25 Feb 2013 13:25:04 +0100
Message-ID: <CALLzPKaukwrybVjR650G9-HQ3J70g+MDBa=Q-MmbBeh1j-1oZQ@mail.gmail.com>
Subject: Re: [RFC 1/1] xattr: provide integrity. namespace to read real values
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        casey@schaufler-ca.com, zohar@linux.vnet.ibm.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 9:05 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Feb 13, 2013 at 11:07:49AM +0200, Dmitry Kasatkin wrote:
>> User space tools use getxattr() system call to read values of extended
>> attributes. getxattr() system call uses vfs_getattr(), which for "security."
>> namespace might get a value of the xattr indirectly from LSM via calling
>> xattr_getsecurity(). For that reason value set by setxattr and read by getxattr
>> might differ.
>>
>> Here is an example of SMACK label, which shows that set and read values are
>> different:
>>
>>   setfattr -n security.SMACK64 -v "hello world" foo
>>   getfattr -n security.SMACK64 foo
>>   # file: foo
>>   security.SMACK64="hello"
>>
>> EVM uses vfs_getxattr_alloc(), which directly reads xattr values from the file
>> system. When performing the file system labeling with digital signatures, it is
>> necessary to read real xattr values in order to generate the correct signatures.
>>
>> This patch adds the virtual "integrity." name space, which allows to bypass
>> calling LSM and read real extended attribute values.
>>
>>   getfattr -e text -n integrity.SMACK64 foo
>>   # file: foo
>>   integrity.SMACK64="hello world"
>
> Without knowing anything about xattr or LSM, to me it is odd that I
> write an xattr using name "security.SMACK64" and read back the same
> attribute using different name "integrity.SMACK64".
>

It might sound like that, but writing and reading security attributes,
might give different results in security. namespace.
We cannot break userspace and change semantics of calls.
This is a trivial workaround which:
(1) does not to break userspace and
(2) does not require user space modifications.

Please suggest anything else?

- Dmitry

> Thanks
> Vivek
