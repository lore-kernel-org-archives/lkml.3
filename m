Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab3FRW30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 18:29:26 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:55978 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449Ab3FRW3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 18:29:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130618063858.3645.75676.stgit@localhost.localdomain>
References: <20130617082135.GB7203@pd.tnic>
	<20130618063858.3645.75676.stgit@localhost.localdomain>
Date: Tue, 18 Jun 2013 15:29:22 -0700
Message-ID: <CA+8MBbL+iLkAXp0ytQwydpuow05jMzSDFMogx1RcMN715yBFbQ@mail.gmail.com>
Subject: Re: [PATCH] Re: [Patch] MCE, APEI: Don't enable CMCI when Firmware
 First mode is set in
From: Tony Luck <tony.luck@gmail.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>, ananth@in.ibm.com,
        masbock@linux.vnet.ibm.com, lcm@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        Huang Ying <ying.huang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 11:43 PM, Naveen N. Rao
<naveen.n.rao@linux.vnet.ibm.com> wrote:
> +       if (bank >= mca_cfg.banks) {
> +               pr_info("mce_disable_bank: Invalid MCA bank %d ignored.\n", bank);

Let's have a FW_BUG in that message to point a finger at the source of
the problem.


+       apei_hest_parse(hest_parse_cmc, NULL);

I think we want a boot command line option to opt out of this. "nohestcmc"??

-Tony
