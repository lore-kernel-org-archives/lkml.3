Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbaFIVrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 17:47:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45058 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbaFIVrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 17:47:04 -0400
Message-ID: <53962B54.8030909@suse.cz>
Date: Mon, 09 Jun 2014 23:47:00 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>, Stephen Boyd <sboyd@codeaurora.org>
CC: linux-kernel@vger.kernel.org, Mitchel Humpherys <mitchelh@codeaurora.org>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2] coccinelle: Check for missing NULL terminators in
 of_device_id tables
References: <1401213858-31950-1-git-send-email-sboyd@codeaurora.org> <alpine.DEB.2.02.1406031208380.2036@localhost6.localdomain6> <538E09C1.30200@codeaurora.org> <alpine.DEB.2.02.1406032013150.2009@localhost6.localdomain6> <538E119D.8010304@codeaurora.org> <alpine.DEB.2.02.1406032022540.2009@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1406032022540.2009@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 3.6.2014 20:25, Julia Lawall napsal(a):
> From: Stephen Boyd <sboyd@codeaurora.org>
> 
> Failure to terminate an of_device_id table can lead to confusing
> failures depending on where the compiler places the array. Add a
> check to make sure these tables are terminated. Thanks to Mitchel
> Humpherys for coming up with the pattern initially.
> 
> Cc: Mitchel Humpherys <mitchelh@codeaurora.org>
> Cc: Julia Lawall <Julia.Lawall@lip6.fr>
> Cc: Gilles Muller <Gilles.Muller@lip6.fr>
> Cc: Nicolas Palix <nicolas.palix@imag.fr>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Acked-by: Grant Likely <grant.likely@linaro.org>
> Signed-off-by: Julia Lawall <julia.lawall@lip6.fr>
> 
> ---
> 
> v3: Removed unneeded rule bad_of_table.  Placed * in context rule on the 
> closing brace; putting it on the field caused all fields to be marked.
> 
> v4: corrected authorship
> 
>  scripts/coccinelle/misc/of_table.cocci |   62 +++++++++++++++++++++++++++++++++
>  1 file changed, 62 insertions(+)

Applied to kbuild.git#misc, thanks. BTW, what is so special about of
device drivers? Shouldn't we check for missing sentinels in all kinds of
device tables?

Thanks,
Michal
