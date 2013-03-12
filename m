Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab3CLJut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 05:50:49 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35975 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932274Ab3CLJus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 05:50:48 -0400
Date: Tue, 12 Mar 2013 15:16:42 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: acme@redhat.com, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix segfault in perf probe
Message-ID: <20130312094642.GA24260@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130312090217.GC4668@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130312090217.GC4668@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031209-9360-0000-0000-0000114873B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ananth N Mavinakayanahalli <ananth@in.ibm.com> [2013-03-12 14:32:17]:

> From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> 
> Fix segfault in perf probe due to a bug introduced by commit d8639f068
> (perf tools: Stop using 'self' in strlist).
> 
> 
> Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> 
> ---
> Index: linus/tools/perf/util/strlist.c
> ===================================================================
> --- linus.orig/tools/perf/util/strlist.c
> +++ linus/tools/perf/util/strlist.c
> @@ -143,7 +143,7 @@ struct strlist *strlist__new(bool dupstr
>  		slist->rblist.node_delete = strlist__node_delete;
> 
>  		slist->dupstr	 = dupstr;
> -		if (slist && strlist__parse_list(slist, list) != 0)
> +		if (list && strlist__parse_list(slist, list) != 0)
>  			goto out_error;
>  	}
> 

-- 
Thanks and Regards
Srikar Dronamraju

