Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab3GRHnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:43:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51793 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab3GRHnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:43:19 -0400
Date: Thu, 18 Jul 2013 08:43:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Chen Gang <gang.chen@asianux.com>
Cc: George Spelvin <linux@horizon.com>, reiserfs-devel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] reiserfs: check/extend buffer length for printing
 functions
Message-ID: <20130718074316.GY4165@ZenIV.linux.org.uk>
References: <51E65A68.8070009@asianux.com>
 <51E76ED7.303@asianux.com>
 <51E7994D.1060300@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E7994D.1060300@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 03:29:17PM +0800, Chen Gang wrote:
> On 07/18/2013 12:28 PM, Chen Gang wrote:
> >  
> >>  	strcpy(fmt1, fmt);
> >> @@ -199,46 +214,51 @@ static void prepare_error_buf(const char *fmt, va_list args)
> >>  	while ((k = is_there_reiserfs_struct(fmt1, &what)) != NULL) {
> >>  		*k = 0;
> >>  
> >> -		p += vsprintf(p, fmt1, args);
> >> +		p += vsnprintf(p, left, fmt1, args);
> 
> At least, need use vscnprintf() instead of vsnprintf(), since we need
> the real written length return.

		n = vsnprintf(p, left, ....);
		left -= n;
		if (left <= 0) /* overflow */
			break;	/* or whatever's suitable here */
		p += n;
