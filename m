Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaKCMHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 07:07:52 -0500
Received: from mga14.intel.com ([192.55.52.115]:49283 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbaKCMHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 07:07:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,307,1413270000"; 
   d="scan'208";a="615967022"
Message-ID: <1415016440.7122.891.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH v2 1/3] firmware loader: Introduce new API -
 request_firmware_abort()
From: Matt Fleming <matt.fleming@intel.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Ming Lei <ming.lei@canonical.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-efi@vger.kernel.org>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Date: Mon, 3 Nov 2014 12:07:20 +0000
In-Reply-To: <20141103101558.GA11739@khazad-dum.debian.net>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
	 <1414984030-13859-2-git-send-email-hock.leong.kweh@intel.com>
	 <20141103101558.GA11739@khazad-dum.debian.net>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [163.33.239.182]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 08:15 -0200, Henrique de Moraes Holschuh wrote:
> On Mon, 03 Nov 2014, Kweh Hock Leong wrote:
> > Note for people who use request_firmware_nowait():
> > You are required to do your own synchronization after you call
> > request_firmware_abort() in order to continue unloading the
> > module. The example synchronization code shows below:
> > 
> > while (THIS_MODULE && module_refcount(THIS_MODULE))
> > 	msleep(20);
> 
> This is _so_ asking for people to get it wrong, it is not funny :-(

Yeah. How about we make request_firmware_abort() synchronous so that
drivers don't have to perform these reference counting games?

