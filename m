Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbaDPVpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:45:45 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:43911 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664AbaDPVpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:45:44 -0400
Date: Wed, 16 Apr 2014 14:45:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <pranith@gatech.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] include/linux/torture.h: remove unused duplicate
 definition
Message-ID: <20140416214541.GB4496@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <534EEC09.7010300@gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534EEC09.7010300@gatech.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041621-7164-0000-0000-000001185529
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 04:46:01PM -0400, Pranith Kumar wrote:
> remove an unused duplicate definition of torture_param
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

This one confused me at first because I could only find one torture_param().
I applied the patch anyway, and it built without errors.  I looked more
closely and realized that the names aren't quite the same.  The one you
removed has only one "a" in the name, and the one remaining has two "a"s
in its name.  ;-)

Good eyes!  I updated the title and commit log and queued for 3.16.

							Thanx, Paul

> ---
>  include/linux/torture.h |    6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/include/linux/torture.h b/include/linux/torture.h
> index b2e2b46..88a84a2 100644
> --- a/include/linux/torture.h
> +++ b/include/linux/torture.h
> @@ -49,12 +49,6 @@
>  #define VERBOSE_TOROUT_ERRSTRING(s) \
>  	do { if (verbose) pr_alert("%s" TORTURE_FLAG "!!! %s\n", torture_type, s); } while (0)
> 
> -/* Definitions for a non-string torture-test module parameter. */
> -#define torture_parm(type, name, init, msg) \
> -	static type name = init; \
> -	module_param(name, type, 0444); \
> -	MODULE_PARM_DESC(name, msg);
> -
>  /* Definitions for online/offline exerciser. */
>  int torture_onoff_init(long ooholdoff, long oointerval);
>  char *torture_onoff_stats(char *page);
> -- 
> 1.7.9.5
> 

