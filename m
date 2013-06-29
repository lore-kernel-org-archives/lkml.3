Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab3F2DDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 23:03:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30483 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab3F2DD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 23:03:29 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=lwbS-oNs0jkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=fZOBIfN-lZIA:10 a=X7Ea-ya5AAAA:8 a=RMqjHzvaxeNGeJ_Q3p4A:9 a=QEXdDO2ut3YA:10 a=nTicbzAlsOkA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372475008.18733.346.camel@gandalf.local.home>
Subject: Re: [PATCH 2/3] sched: fix static keys race in sched_feat
From: Steven Rostedt <rostedt@goodmis.org>
To: jbaron@akamai.com
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, mingo@kernel.org,
        peterz@infradead.org
Date: Fri, 28 Jun 2013 23:03:28 -0400
In-Reply-To: <d0bf4b2675cde8fed2892975a757bbfe5ecc25ec.1372457176.git.jbaron@akamai.com>
References: <cover.1372457176.git.jbaron@akamai.com>
	 <d0bf4b2675cde8fed2892975a757bbfe5ecc25ec.1372457176.git.jbaron@akamai.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-28 at 22:30 +0000, jbaron@akamai.com wrote:
> As pointed out by Andi Kleen, thue usage of static keys can be racy in

"thue"

> sched_feat_disable vs. sched_feat_enable(). Currently, we first check the
> value of keys->enabled, and subsequently update the branch direction. This,
> can be racy and can potentially leave the keys in an inconsistent state.
> 
> Fix the race by using static_key_slow_set_true()/false(), which does the the
> check and set using the jump_label_mutex.
> 
> Signed-off-by: Jason Baron <jbaron@akamai.com>

-- Steve


