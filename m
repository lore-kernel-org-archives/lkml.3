Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbaAGQv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 11:51:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:52171 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaAGQvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 11:51:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,619,1384329600"; 
   d="scan'208";a="462988581"
Message-ID: <1389113497.2735.142.camel@acox1-desk.ger.corp.intel.com>
Subject: Re: [RFC DO NOT MERGE] tty: n_gsm: support buggy modem
From: Alan Cox <alan@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Lars Poeschel <poeschel@lemonage.de>, jslaby@suse.cz,
        linux-kernel@vger.kernel.org, xiaojin <jin.xiao@intel.com>,
        Ken Mills <ken.k.mills@intel.com>,
        Dirkjan Bussink <d.bussink@gmail.com>
Date: Tue, 07 Jan 2014 16:51:37 +0000
In-Reply-To: <20140107142050.GB32491@kroah.com>
References: <4386658.RncifLMAGy@lem-wkst-02>
	 <20140107142050.GB32491@kroah.com>
Organization: Intel Corporation
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > modem status command, but this DV bit is not set. With this patch the modem
> > and the whole mux is working fine. Another way makeing all this work is
> > setting the carrier_raised function to NULL. The tty code assumes that
> > everything is alright then.

Which means your modem has decided it doesn't yet have a carrier. Do you
get a carrier after ATD completes with a CONNECTED message ?

(you can open with O_NDELAY to avoid blocking on the open)

Alan


