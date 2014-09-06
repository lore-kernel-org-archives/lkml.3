Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaIFSTJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 14:19:09 -0400
Received: from smtprelay0216.hostedemail.com ([216.40.44.216]:60729 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751371AbaIFSTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 14:19:07 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3871:3872:4321:5007:7652:7903:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12438:12517:12519:12740:13069:13161:13229:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: home58_4f356b61abc55
X-Filterd-Recvd-Size: 2777
Message-ID: <1410027543.2723.8.camel@joe-AO725>
Subject: Re: [PATCH 2/3] staging: lustre: fix pointer whitespace style
From: Joe Perches <joe@perches.com>
To: Spencer Baugh <sbaugh@andrew.cmu.edu>
Cc: gregkh@linuxfoundation.org, Oleg Drokin <oleg.drokin@intel.com>,
        Niu Yawei <yawei.niu@intel.com>,
        Hongchao Zhang <hongchao.zhang@intel.com>,
        Alex Zhuravlev <alexey.zhuravlev@intel.com>,
        Masanari Iida <standby24x7@gmail.com>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Sat, 06 Sep 2014 11:19:03 -0700
In-Reply-To: <1410025111-31422-2-git-send-email-sbaugh@andrew.cmu.edu>
References: <1410025111-31422-1-git-send-email-sbaugh@andrew.cmu.edu>
	 <1410025111-31422-2-git-send-email-sbaugh@andrew.cmu.edu>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-09-06 at 13:38 -0400, Spencer Baugh wrote:
> Fix errors reported by checkpatch of this kind:
[]
> diff --git a/drivers/staging/lustre/lustre/include/lustre_import.h b/drivers/staging/lustre/lustre/include/lustre_import.h
[]
> @@ -103,9 +103,9 @@ enum lustre_imp_state {
>  };
>  
>  /** Returns test string representation of numeric import state \a state */
> -static inline char * ptlrpc_import_state_name(enum lustre_imp_state state)
> +static inline char *ptlrpc_import_state_name(enum lustre_imp_state state)
>  {
> -	static char* import_state_names[] = {
> +	static char *import_state_names[] = {
>  		"<UNKNOWN>", "CLOSED",  "NEW", "DISCONN",
>  		"CONNECTING", "REPLAY", "REPLAY_LOCKS", "REPLAY_WAIT",
>  		"RECOVER", "FULL", "EVICTED",

This likely shouldn't be static inline, but an actual
function somewhere.

The return should probably be const char *.

Indexing a string array with an enum is generally unsafe.

I think it better to use a switch/case like:

const char *ptlrpc_import_state_name(enum lustre_imp_state state)
{
	switch (state) {
	case LUSTRE_IMP_CLOSED:
		return "CLOSED";
	case LUSTRE_IMP_NEW:
		return "NEW";
	case LUSTRE_IMP_DISCON:
		return "DISCONN";
	case LUSTRE_IMP_CONNECTING:
		return "CONNECTING";
	case LUSTRE_IMP_REPLAY:
		return "REPLAY";
	case LUSTRE_IMP_REPLAY_LOCKS:
		return "REPLAY_LOCKS";
	case LUSTRE_IMP_REPLAY_WAIT:
		return "REPLAY_WAIT";
	case LUSTRE_IMP_RECOVER:
		return "RECOVER";
	case LUSTRE_IMP_FULL:
		return "FULL";
	case LUSTRE_IMP_EVICTED:
		return "EVICTED";
	default:
		return "UNKNOWN";
	}
}


