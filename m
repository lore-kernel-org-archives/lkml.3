Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab3CMLVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:21:53 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:44469 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756330Ab3CMLVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:21:51 -0400
Message-ID: <5140614D.2060102@mimc.co.uk>
Date: Wed, 13 Mar 2013 11:21:49 +0000
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, adrian.hunter@intel.com
Subject: Re: MTD : Kernel oops when remounting ubifs as read/write
References: <5134CEF9.5070502@mimc.co.uk>  <1363087506.3348.62.camel@sauron.fi.intel.com>  <51405F3A.3090901@mimc.co.uk> <1363173638.11441.24.camel@sauron.fi.intel.com>
In-Reply-To: <1363173638.11441.24.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/03/13 11:20, Artem Bityutskiy wrote:
> On Wed, 2013-03-13 at 11:12 +0000, Mark Jackson wrote:
>>> -	if (c->space_fixup) {
>>> -		err = ubifs_fixup_free_space(c);
>>> -		if (err)
>>> -			goto out;
>>> -	}
>>> -
>>>  	mutex_unlock(&c->umount_mutex);
>>>  	return err;
>>>
>>
>> Sorry ... this just locks up the unit.
> 
> Am I right that to reproduce it I need any image with the 'fixup' flag
> set, then I should put it on the flash, mount it R/O and then remount
> R/W. Right?
> 

Yes ... this is on a custom AM335x board, where the ubi image must be created
with the "-F" flag.

Cheers
Mark J.
