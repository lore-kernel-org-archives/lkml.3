Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbaCEWUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 17:20:11 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:43056 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaCEWUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 17:20:07 -0500
MIME-Version: 1.0
In-Reply-To: <1394035440.10148.129.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
	<20312cf18c698d0e918bde022a76edf2705f1e17.1393599538.git.d.kasatkin@samsung.com>
	<1393900797.10148.41.camel@dhcp-9-2-203-236.watson.ibm.com>
	<531541DB.7000406@schaufler-ca.com>
	<1393903276.10148.51.camel@dhcp-9-2-203-236.watson.ibm.com>
	<CACE9dm8qTb1vWS-1KFrYpOkX1RoQPe0oKyyGtTw7c+4PJCJKLA@mail.gmail.com>
	<1393965405.10148.112.camel@dhcp-9-2-203-236.watson.ibm.com>
	<CACE9dm8F2uPqeSuMwCjRBtdCJ-kfrw_v581P3W+kVQJR5Ninqg@mail.gmail.com>
	<1394035440.10148.129.camel@dhcp-9-2-203-236.watson.ibm.com>
Date: Thu, 6 Mar 2014 00:20:05 +0200
Message-ID: <CACE9dm9ZPOwHO8Tf3y4k0=VmKBzYDRws6iOhbmnugbKnKcVqqA@mail.gmail.com>
Subject: Re: [PATCH 8/8] evm: introduce EVM hmac xattr list
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2014 at 6:04 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Wed, 2014-03-05 at 11:26 +0200, Dmitry Kasatkin wrote:
>> On Tue, Mar 4, 2014 at 10:36 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>> > On Tue, 2014-03-04 at 16:18 +0200, Dmitry Kasatkin wrote:
>> >> On Tue, Mar 4, 2014 at 5:21 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>> >> > On Mon, 2014-03-03 at 19:00 -0800, Casey Schaufler wrote:
>> >> >> On 3/3/2014 6:39 PM, Mimi Zohar wrote:
>> >> >> > On Fri, 2014-02-28 at 16:59 +0200, Dmitry Kasatkin wrote:
>> >> >> >> EVM currently uses source hard coded list of xattrs which needs to be
>> >> >> >> included into the HMAC calculation. This is very unflexible.
>> >> >> >> Adding new attributes requires modifcation of the source code and
>> >> >> >> prevents building the kernel which works with previously labeled
>> >> >> >> filesystems.
>> >> >> >>
>> >> >> >> Early versions of Smack used only one xattr security.SMACK64,
>> >> >> >> which is protected by EVM. Now Smack has a few more attributes and
>> >> >> >> they are not protected. Adding support to the source code makes it
>> >> >> >> impossible to use new kernel with previousely labeled filesystems.
>> >> >> > I think this patch will break any existing filesystems labeled with
>> >> >> > 'security.smack64'.  Details inline.
>> >> >> >
>> >> >> >> This patch replaces hardcoded xattr array with dynamic list which is
>> >> >> >> initialized from CONFIG_EVM_HMAC_XATTRS variable. It allows to build
>> >> >> >> kernel with with support of older and newer EVM HMAC formats.
>> >
>> > So instead of having a single kernel, this allows you to build different
>> > kernels with different xattr labels included in the HMAC.  Wouldn't you
>> > want a migration mode, similar to 'fix' mode, that only updates the
>> > HMAC, if the existing HMAC verified based on the prior set of xattrs?
>> >
>>
>> It would require to maintain 2 sets of xattrs: "old" and "new".
>> What if "new" becomes "old" again, while there were still not updated
>> previous "old" :)
>>
>> I think it would bring unnecessary complexity.
>> System designers define what xattrs they want to protect and stick with that.
>> Filesystems stays anyway, but allows to upgrade to new kernels.
>>
>> If someone really wants to upgrade the system, just use "evm=fix" and run
>> recursive fix.., e.g. 'evmctl -r ima_fix /'
>
> Right, but instead of fixing everything, we would want a "safe" fix.
> Verify the existing HMAC, before updating the HMAC based on the new set
> of xattrs.  With this design, only an "old" and "new" set of xattrs
> would be needed.
>

This can be the next step further.
Now we need to support new xattrs in the kernel, without breaking
existing labeled filesystem.

Dmitry


> Mimi
>



-- 
Thanks,
Dmitry
