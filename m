Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaEGFqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 01:46:42 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:39740 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaEGFqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 01:46:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140506191105.GV18016@ZenIV.linux.org.uk>
References: <5368E46B.9050708@samsung.com>
	<20140506165901.GS18016@ZenIV.linux.org.uk>
	<1399401557.9468.21.camel@dhcp-9-2-203-236.watson.ibm.com>
	<20140506191105.GV18016@ZenIV.linux.org.uk>
Date: Wed, 7 May 2014 08:46:38 +0300
Message-ID: <CACE9dm_YdxyY152dnVB4EC9FoyzdtEp5MfFnhcs0MK=xnS+HHQ@mail.gmail.com>
Subject: Re: IMA & truncate
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 May 2014 22:11, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, May 06, 2014 at 02:39:17PM -0400, Mimi Zohar wrote:
>
>> Al, you're not going to like this, but ima_calc_file_hash() calls
>> ima_calc_file_hash_tfm(), which already sets/unsets FMODE_READ in order
>> to calculate the file hash.
>
> And if it happens to be on NFS and server says "no reads for you"?

Sorry for repost. Lousy Android gmail client is not able to send with
plain text, even with reply.

IMA works by policy. It ignores non-local file systems by default.

But if someone still tries to enable nfs in the custom policy, it
might get into such situation. But then there are other issues like
security xattrs. Anyone using ima needs to be aware what he does.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thanks,
Dmitry
