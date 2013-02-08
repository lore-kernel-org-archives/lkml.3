Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946506Ab3BHMuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 07:50:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48126 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946353Ab3BHMuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 07:50:39 -0500
Date: Fri, 8 Feb 2013 12:50:37 +0000
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH v3] regmap: debugfs: Add a registers `range' file
Message-ID: <20130208125037.GA11827@opensource.wolfsonmicro.com>
References: <1359720339-14862-1-git-send-email-dp@opensource.wolfsonmicro.com> <20130208114654.GQ8879@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130208114654.GQ8879@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 11:46:55AM +0000, Mark Brown wrote:
> On Fri, Feb 01, 2013 at 12:05:39PM +0000, Dimitris Papastamos wrote:
> 
> > +struct regmap_reg_range  {
> > +	unsigned int start;
> > +	unsigned int end;
> > +	unsigned int attr;
> > +};
> 
> > +	i = start_reg;
> > +	while (i <= map->max_register) {
> > +		reg_attr = regmap_attr_bitmap(map, i);
> > +		switch (state) {
> 
> We're doing a linear scan through the entire register map here in order
> to build up a list of which registers exist, doing it every time the
> file is read.  This data structure looks *very* like the one we have for
> the reads themselves, it seems like we should be sharing the work here
> and using the same cache.

Yea that's true.  Will fix this and re-send.

Thanks,
Dimitris
