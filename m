Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbaI3UDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:03:21 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:9738 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbaI3UDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:03:19 -0400
Date: Tue, 30 Sep 2014 13:03:30 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Andy Gross <agross@codeaurora.org>
CC: Wolfram Sang <wsa@the-dreams.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] i2c: qup: Fix order of runtime pm initialization
Message-ID: <20140930200329.GV28481@sonymobile.com>
References: <1412028051-21774-1-git-send-email-agross@codeaurora.org>
 <20140930015323.GE28481@sonymobile.com>
 <20140930195923.GB26928@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140930195923.GB26928@qualcomm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 30 Sep 12:59 PDT 2014, Andy Gross wrote:

> On Mon, Sep 29, 2014 at 06:53:24PM -0700, Bjorn Andersson wrote:
> > On Mon 29 Sep 15:00 PDT 2014, Andy Gross wrote:
> > 
> > > The runtime pm calls need to be done before populating the children via the
> > > i2c_add_adapter call.  If this is not done, a child can run into issues trying
> > > to do i2c read/writes due to the pm_runtime_sync failing.
> > > 
> > 
> > May I ask in what case this would fail?  I thought we tested this as we found
> > the faulty error check after calling pm_runtime_get_sync().
> 
> This is a different kind of failure.   If during probe, the children do some I2C
> activity, they will encounter issues with the runtime_sync due to the pm_runtime
> not being initialized.  However, once the qup probe completes, everything works
> fine.
> 
> The original runtime_sync issue revolved around the runtime_sync return value
> being misinterpreted due to the incorrect check.
> 

Yeah, I just wondered why my testing didn't trigger this. But I suspect that
the answer is simply that the client I ran with did not do i2c accesses from
probe.

Regards,
Bjorn
