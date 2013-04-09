Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935499Ab3DIRLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:11:16 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:58378 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759419Ab3DIRLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:11:15 -0400
Message-ID: <51644BAF.7080202@kernel.org>
Date: Tue, 09 Apr 2013 18:11:11 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bill Pemberton <wfp5p@virginia.edu>, Joe Perches <joe@perches.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH] staging/adt7316 Fix some 'interesting' string operations
References: <515df29417437372eb@agluck-desk.sc.intel.com> <515FF438.6090305@metafoo.de> <3908561D78D1C84285E8C5FCA982C28F1EA4089E@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1EA4089E@ORSMSX104.amr.corp.intel.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 06:54 PM, Luck, Tony wrote:
>> I think it is a good idea to switch directly to strtobool. But anyway, if you
>> don't want to respin the patch it is fine as it is.
> I didn't know that strtobool() existed ... but now that I do I agree that it would
> be better to use it here.  But ... I'm less comfortable updating the patch to use
> it. User visible behavior would change (currently just "1" is considered "true",
> but strtobool would also accept "y" and "Y").  I'd also have to think hard about
> what to do if strtobool() said the input was not a valid boolean.
>
> Thanks for the review.
>
> -Tony
I'll take the patch as is.  If anyone wants to do the strtobool conversion
as a follow up that would be great as well.  As a staging driver which doesn't
terribly closely correspond to any standard abi's I'd be inclined to not worry
to much about breaking userspace code that relies on the exact comparison
currently used as long as the obvious case still works.

Patch applied to togreg branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git

Thanks,

Jonathan
