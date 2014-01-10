Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaAJIYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 03:24:20 -0500
Received: from smtprelay03.ispgateway.de ([80.67.31.41]:60292 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbaAJIYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 03:24:16 -0500
X-Greylist: delayed 616 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jan 2014 03:24:16 EST
Message-ID: <52CFABC5.5030806@ladisch.de>
Date: Fri, 10 Jan 2014 09:13:57 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>
CC: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Stephan Mueller <stephan.mueller@atsec.com>
Subject: Re: [RFC PATCH] char: random: stir the output pools differently when
 the random_write lenght allows splitting the seed
References: <42f6dc88535d5ecdab13b1376db7ccbbbc550600.1389297772.git.aquini@redhat.com>
In-Reply-To: <42f6dc88535d5ecdab13b1376db7ccbbbc550600.1389297772.git.aquini@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael Aquini wrote:
> This patch introduces changes to the random_write method so it can split the
> given seed and completely stir the output pools with different halves of it,
> when seed lenght allows us doing so.
>
> -	ret = write_pool(&blocking_pool, buffer, count);
> +	ret = write_pool(pool1, buffer, count1);
>  	if (ret)
>  		return ret;
> -	ret = write_pool(&nonblocking_pool, buffer, count);
> +	ret = write_pool(pool2, buffer + offset, count2);

Doesn't this assume that both halves of the buffer contain some
(uncredited) entropy?  In other words, wouldn't this result in worse
randomness for pool2 if the second half of the buffer contains just zero
padding?


Regards,
Clemens
