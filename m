Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbaFEPyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:54:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaFEPyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:54:17 -0400
Date: Thu, 5 Jun 2014 08:57:58 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Marc Dionne <marc.c.dionne@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 3.4 214/214] HID: logitech: dont use stack based
 dj_report structures
Message-ID: <20140605155758.GE23993@kroah.com>
References: <20140605041639.638675216@linuxfoundation.org>
 <20140605041708.243134847@linuxfoundation.org>
 <CAB9dFdvqvqpF0b5mT63VjF2zDP4Eh7xGHX1iLFZY_NWk_YX7bQ@mail.gmail.com>
 <53905E98.3080709@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53905E98.3080709@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 08:12:08PM +0800, Yijing Wang wrote:
> >> -       dj_report.report_type = REPORT_TYPE_CMD_GET_PAIRED_DEVICES;
> >> -       return logi_dj_recv_send_report(djrcv_dev, &dj_report);
> >> +       dj_report = kzalloc(sizeof(dj_report), GFP_KERNEL);
> > 
> > This patch was unfortunately incorrect as is - it needs to allocate
> > sizeof(struct dj_report) here and a little further down.  This was
> > later fixed in mainline by 8a55ade7655, which should also be included
> > if you take this - I don't see it in the current set.
> 
> Good catch, I'm so sorry, I missed this fix patch. Marc, thanks for your review.
> 
> Hi Greg, Can you cherry pick this fix patch?   upstream commit id: 8a55ade7655(dj: memory scribble in logi_dj).

Now applied, thanks.

greg k-h
