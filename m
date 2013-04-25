Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760Ab3DYOkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:40:52 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60154 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab3DYOkv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:40:51 -0400
Message-ID: <1366900849.10438.12.camel@hornet>
Subject: Re: [PATCH] mfd: vexpress: Handle pending config transactions
From: Pawel Moll <pawel.moll@arm.com>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 25 Apr 2013 15:40:49 +0100
In-Reply-To: <1366894965.3528.19.camel@computer5.home>
References: <1366821084-12815-1-git-send-email-pawel.moll@arm.com>
	 <1366894965.3528.19.camel@computer5.home>
X-Mailer: Evolution 3.6.2-0ubuntu0.1
Mime-Version: 1.0
X-OriginalArrivalTime: 25 Apr 2013 14:40:49.0538 (UTC) FILETIME=[E10B0620:01CE41C2]
X-MC-Unique: 113042515404905601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-25 at 14:02 +0100, Jon Medhurst (Tixy) wrote:
> > +	while (!list_empty(&bridge->transactions)) {
> > +		trans = list_first_entry(&bridge->transactions,
> > +				struct vexpress_config_trans, list);
> >  
> > -		bridge->info->func_exec(trans->func->func, trans->offset,
> > -				trans->write, trans->data);
> > +		vexpress_config_dump_trans("Executing pending", trans);
> > +		status = bridge->info->func_exec(trans->func->func,
> > +				trans->offset, trans->write, trans->data);
> > +
> > +		if (status == VEXPRESS_CONFIG_STATUS_DONE)
> > +			vexpress_config_dump_trans("Finished pending", trans);
> > +		else
> > +			break;
> 
> For each transaction we execute in this loop, don't we also need to do
> the actions vexpress_config_complete does? E.g.
> 
> 	trans->status = status;
> 	list_del(&trans->list);
> 	complete(&trans->completion);
> 
> except in the case status==VEXPRESS_CONFIG_STATUS_WAIT.

You're completely right. I shouldn't have write this code as the last
thing in the afternoon...

Will send v2.

Paweł


