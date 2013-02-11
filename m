Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab3BKLwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 06:52:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49722 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398Ab3BKLwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 06:52:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [char-misc-next 03/11] mei: bus: Initial implementation for I/O routines
Date: Mon, 11 Feb 2013 11:52:42 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: Tomas Winkler <tomas.winkler@intel.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
References: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com> <201302072234.44181.arnd@arndb.de> <20130207225510.GD5072@sortiz-mobl>
In-Reply-To: <20130207225510.GD5072@sortiz-mobl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302111152.42483.arnd@arndb.de>
X-Provags-ID: V02:K0:iY3Zj9HE6WI+NHqTvEb1phcGRebEoUodzLU1Z5dONac
 I6MhyNeh/UEOX1LMT2FAIsRbJxW3dO92GqVfdct1iKijzgzCYs
 7jV8iyoXWoTNS+j4vAmuaU2MRKgiwRlRJfFPD1IQdl6D3CmUWQ
 jejfgxgb83EsEQRD/+aYmSxmLWSoddVThxgwYx27sScWQdUC4p
 ewYx/idJH94EtpJrHNd58o6efksyp5ZMrK1BI2zhS2aGudQulZ
 f/WeIKSAXbN7H243SA3DA3sBO6GZOsvRzAppTbfhEWCrdvbagr
 bUSvlmhuDRjCSOyA8kOlm07Xx46zArbcjpK+7nG9ts7Z7j9YQb
 e2SDE/DEgHSHviu4D2js=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2013, Samuel Ortiz wrote:
> On Thu, Feb 07, 2013 at 10:34:44PM +0000, Arnd Bergmann wrote:
> > On Thursday 07 February 2013, Tomas Winkler wrote:
> > > +
> > > +struct mei_bus_ops {
> > > +       int (*send)(struct mei_bus_client *client, u8 *buf, size_t length);
> > > +       int (*recv)(struct mei_bus_client *client, u8 *buf, size_t length);
> > > +};
> > > +
> > 
> > Can you have more than one set of mei_bus_ops in a driver? 
> You can have at most one mei_bus_ops per mei_bus_client.
> 
> > If not, how about adding the callbacks to the mei_bus_driver structure
> > directly as a simplification? 
> I can add the ops directly to the mei_bus_client structure, yes.

I looked at the new version, and it's not what I assumed it would be.
I thought the operations were specific to a client driver and should
be part of the /mei_bus_driver/ structure, not the /mei_bus_client/.

Did I misunderstand what these functions do, or did you misunderstand
what I was asking for?

	Arnd
