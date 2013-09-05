Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab3IEOoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 10:44:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab3IEOoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 10:44:02 -0400
Date: Thu, 5 Sep 2013 10:43:53 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Aravind.Gopalakrishnan@amd.com
Subject: Re: amd64_edac: Add ECC decoding support for newer F15h models
Message-ID: <20130905144353.GB15894@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Aravind.Gopalakrishnan@amd.com
References: <20130904185224.67DFF660948@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130904185224.67DFF660948@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 06:52:24PM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=18b94f66f9537003cee30d475d79a57c58f1e1d8
 > Commit:     18b94f66f9537003cee30d475d79a57c58f1e1d8
 > Parent:     7d64ac6422092adbbdaa279ab32f9d4c90a84558
 > Author:     Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
 > AuthorDate: Fri Aug 9 11:54:49 2013 -0500
 > Committer:  Borislav Petkov <bp@suse.de>
 > CommitDate: Mon Aug 12 16:00:10 2013 +0200
 > 
 >     amd64_edac: Add ECC decoding support for newer F15h models

 > +static int f15_m30h_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
 > +					u64 sys_addr, int *chan_sel)
 > +{
 > +	...
 > +	u8 channel, alias_channel, leg_mmio_hole, dct_sel, dct_offset_en;
        ^^^^^^^^^^

 > +
 > +  ....
 > +
 > +	channel = f15_m30h_determine_channel(pvt, sys_addr, intlv_en,
 > +					     num_dcts_intlv, dct_sel);
 > +
 > +	/* Verify we stay within the MAX number of channels allowed */
 > +	if (channel > 4 || channel < 0)
 > +		return -EINVAL;
 
Channel will never be < 0, as it's unsigned.

	Dave

