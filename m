Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab3L0Jph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 04:45:37 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59624 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab3L0Jpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 04:45:36 -0500
Date: Fri, 27 Dec 2013 10:45:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo DImitrov <ivo.g.dimitrov.75@gmail.com>
Cc: gregkh@linuxfoundation.org, omar.ramirez@copitl.com, pali.rohar@gmail.com,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH] Staging: tidspbridge: Use hashtable implementation
Message-ID: <20131227094532.GA17143@amd.pavel.ucw.cz>
References: <1387992592-3208-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387992592-3208-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Ivaylo Dimitrov <freemangordon@abv.bg>
> 
> Use upstream hashtable implementation instead of generic code
> 
> Signed-off-by: Ivaylo Dimitrov <freemangordon@abv.bg>

> @@ -991,8 +989,11 @@ static struct dynload_symbol *dbll_add_to_symbol_table(struct dynamic_loader_sym
>  		sym_ptr =
>  		    (struct dbll_symbol *)gh_insert(lib->sym_tab, (void *)name,
>  						    (void *)&symbol);
> -		if (sym_ptr == NULL)
> +		if (IS_ERR(sym_ptr))
> +		{

You want this { to go to the previous line. Otherwise looks good,

Reviewed-by: Pavel Machek <pavel@ucw.cz>

Thanks,

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
