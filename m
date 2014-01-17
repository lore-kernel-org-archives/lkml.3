Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaAQSP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 13:15:57 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:55352 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbaAQSPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 13:15:55 -0500
Message-ID: <1389982549.27141.15.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH net-next v2 2/3] net: add trim helper and convert users
From: Ben Hutchings <bhutchings@solarflare.com>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
CC: <netdev@vger.kernel.org>, Daniel Borkmann <dborkman@redhat.com>,
        "Jakub Zawadzki" <darkjames-ws@darkjames.pl>,
        Eric Dumazet <eric.dumazet@gmail.com>, <linux-kernel@vger.kernel.org>
Date: Fri, 17 Jan 2014 18:15:49 +0000
In-Reply-To: <1389918519-23779-3-git-send-email-hannes@stressinduktion.org>
References: <1389918519-23779-1-git-send-email-hannes@stressinduktion.org>
	 <1389918519-23779-3-git-send-email-hannes@stressinduktion.org>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20440.003
X-TM-AS-Result: No--8.496400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-17 at 01:28 +0100, Hannes Frederic Sowa wrote:
[...]
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -193,6 +193,25 @@ extern int _cond_resched(void);
>  		(__x < 0) ? -__x : __x;		\
>  	})
>  
> +/**
> + * trim - perform a reciprocal multiplication in order to "clamp" a
> + *        value into range [0, ep_ro), where the upper interval
> + *        endpoint is right-open. This is useful, e.g. for accessing
> + *        a index of an array containing ep_ro elements, for example.
> + *        Think of it as sort of modulus, only that the result isn't
> + *        that of modulo. ;)
> + *        More: http://homepage.cs.uiowa.edu/~jones/bcd/divide.html
[...]

And you think trim() is an obvious name for that?!
How about: scale_u32_to_range().

Also the first physical line of a kernel-doc comment (after the name) is
a summary which is used, for example, in the summary line on a manual
page.  It seems like you have the summary and full description the wrong
way round here.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

