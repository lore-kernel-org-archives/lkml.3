Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761618Ab3BNUG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 15:06:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758688Ab3BNUGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 15:06:54 -0500
Date: Thu, 14 Feb 2013 15:05:57 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        casey@schaufler-ca.com, zohar@linux.vnet.ibm.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC 1/1] xattr: provide integrity. namespace to read real values
Message-ID: <20130214200557.GF16671@redhat.com>
References: <959cfd74266e82f72e5879c6c8b798d76f6cad31.1360746454.git.dmitry.kasatkin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <959cfd74266e82f72e5879c6c8b798d76f6cad31.1360746454.git.dmitry.kasatkin@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 11:07:49AM +0200, Dmitry Kasatkin wrote:
> User space tools use getxattr() system call to read values of extended
> attributes. getxattr() system call uses vfs_getattr(), which for "security."
> namespace might get a value of the xattr indirectly from LSM via calling
> xattr_getsecurity(). For that reason value set by setxattr and read by getxattr
> might differ.
> 
> Here is an example of SMACK label, which shows that set and read values are
> different:
> 
>   setfattr -n security.SMACK64 -v "hello world" foo
>   getfattr -n security.SMACK64 foo
>   # file: foo
>   security.SMACK64="hello"
> 
> EVM uses vfs_getxattr_alloc(), which directly reads xattr values from the file
> system. When performing the file system labeling with digital signatures, it is
> necessary to read real xattr values in order to generate the correct signatures.
> 
> This patch adds the virtual "integrity." name space, which allows to bypass
> calling LSM and read real extended attribute values.
> 
>   getfattr -e text -n integrity.SMACK64 foo
>   # file: foo
>   integrity.SMACK64="hello world"

Without knowing anything about xattr or LSM, to me it is odd that I
write an xattr using name "security.SMACK64" and read back the same
attribute using different name "integrity.SMACK64".

Thanks
Vivek
