Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbaJASpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:45:06 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52464 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbaJASpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:45:01 -0400
MIME-Version: 1.0
In-Reply-To: <20141001184304.GA6832@svl-evodev-groeck.juniper.net>
References: <CAAVjN7dwS62EKMnuZc_P1UjkbRVk6RXqJ91GwWZ96bbY5Ct-rg@mail.gmail.com>
	<CAAVjN7eUmBVcAGPbcn3qsJ9M9uu2nkFoKHqGhhKGekZSceGiMw@mail.gmail.com>
	<20141001184304.GA6832@svl-evodev-groeck.juniper.net>
Date: Wed, 1 Oct 2014 11:44:59 -0700
Message-ID: <CAAVjN7edpkXYMHBm+wLegA_pc0hnm_YZf_z=Ni3h=EbDTmfegQ@mail.gmail.com>
Subject: Re: Fwd: [Proposal] PM sleep children of inactive I2C bus segments
 off Masters in multi-master systems
From: Danielle Costantino <danielle.costantino@gmail.com>
To: Guenter Roeck <groeck@juniper.net>
Cc: linux-i2c <linux-i2c@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-sending Proposal:

Currently I2C mux devices that support multiple master arbitration are
the i2c-mux-pca9541 and i2c-arb-gpio-challenge drivers. I propose to
add the ability to configure an interrupt pin from the Master Selector
device to indicate that bus ownership has been lost. Once the device
loses ownership, all of its children should enter a pm sleep mode (as
you can't talk to them at this point) until master-ship has been
reacquired.

This has come up as an issue when the master loses control over a bus
the return code of all transactions to its lave devices is EIO (not
very helpful).

Any comments would be appreciated, I am just looking if there is
interest in this.

Thanks,

On Wed, Oct 1, 2014 at 11:43 AM, Guenter Roeck <groeck@juniper.net> wrote:
> On Wed, Oct 01, 2014 at 11:39:49AM -0700, Danielle Costantino wrote:
>> added proper mailing lists...I hope
>>
>
> Hi Danielle,
>
> I don't see the actual proposal, and I don't find anything on the web
> either when looking for the headline :-(.
>
> Guenter



-- 
- Danielle Costantino
