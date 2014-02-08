Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaBHQhm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 11:37:42 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23810 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbaBHQhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 11:37:40 -0500
Message-ID: <52F65D45.5070206@oracle.com>
Date: Sat, 08 Feb 2014 10:37:25 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: "Michael L. Semon" <mlsemon35@gmail.com>,
        JFS Discussion <jfs-discussion@lists.sourceforge.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] jfs: fix generic posix ACL regression
References: <52F54928.9050601@oracle.com> <20140208070818.GA8758@lst.de>
In-Reply-To: <20140208070818.GA8758@lst.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2014 01:08 AM, Christoph Hellwig wrote:
> On Fri, Feb 07, 2014 at 02:59:20PM -0600, Dave Kleikamp wrote:
>> -#ifdef JFS_POSIX_ACL
>> +#ifdef CONFIG_JFS_POSIX_ACL
> 
> Ooops, sorry.
> 
> I don't understand the can_set_xattr move - while the check obviously
> aren't needed when using the generic xattr code I don't see how they
> cause harm either.

Your patchset removed the XATTR_SYSTEM_PREFIX bits from can_set_xattr,
so it will not recognize the ACL as valid and return -EOPNOTSUPP.
