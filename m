Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaCJNcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 09:32:22 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:61612 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbaCJNcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 09:32:20 -0400
Date: Mon, 10 Mar 2014 14:32:15 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: =?iso-8859-1?B?U/hyZW5zZW4s?= Stefan 
	<Stefan.Sorensen@spectralink.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bhutchings@solarflare.com" <bhutchings@solarflare.com>,
        "christian.riesch@omicron.at" <christian.riesch@omicron.at>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH RFC net-next v1 1/9] ptp: introduce programmable pins.
Message-ID: <20140310133215.GA19781@netboy>
References: <cover.1394307303.git.richardcochran@gmail.com>
 <d9cb37a7d6e57d7f103dab78f98044697d3c4433.1394307304.git.richardcochran@gmail.com>
 <1394455989.2296.23.camel@e37108.spectralink.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394455989.2296.23.camel@e37108.spectralink.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 12:53:09PM +0000, Sørensen, Stefan wrote:
> On Sat, 2014-03-08 at 20:42 +0100, Richard Cochran wrote:

> > +int ptp_find_pin(struct ptp_clock *ptp,
> > +		 enum ptp_pin_function func, unsigned int chan)
> > +{
> > +	struct ptp_pin_desc *pin = NULL;
> > +	int i;
> > +
> > +	mutex_lock(&ptp->pincfg_mux);
> > +	for (i = 0; i < ptp->info->n_pins; i++) {
> > +		if (ptp->info->pin_config[i].func == func &&
> > +		    ptp->info->pin_config[i].chan == chan) {
> > +			pin = &ptp->info->pin_config[i];
> > +			break;
> > +		}
> > +	}
> > +	mutex_unlock(&ptp->pincfg_mux);
> > +
> > +	return pin ? pin - ptp->info->pin_config : -1;
> > +}
> 
> Maybe replace 'pin - ptp->info->pin_config' with 'i'?

Yes, of course.

Thanks,
Richard
