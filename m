Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbaFWMQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 08:16:55 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:60895 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaFWMQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 08:16:53 -0400
Date: Mon, 23 Jun 2014 09:16:40 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, hariprasad@chelsio.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cxgb4: use dev_port to identify ports
Message-ID: <20140623121640.GB25780@oc0268524204.ibm.com>
References: <1403354888-15600-1-git-send-email-cascardo@linux.vnet.ibm.com>
 <20140622.172307.2305001882391366010.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140622.172307.2305001882391366010.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062312-1798-0000-0000-000002F43711
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2014 at 05:23:07PM -0700, David Miller wrote:
> From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
> Date: Sat, 21 Jun 2014 09:48:08 -0300
> 
> > Commit 3f85944fe207d0225ef21a2c0951d4946fc9a95d ("net: Add sysfs file
> > for port number") introduce dev_port to network devices. cxgb4 adapters
> > have multiple ports on the same PCI function, and used dev_id to
> > identify those ports. That use was removed by commit
> > 8c367fcbe6549195d2eb11e62bea233f811aad41 ("cxgb4: Do not set
> > net_device::dev_id to VI index"), since dev_id should be used only when
> > devices share the same MAC address.
> > 
> > Using dev_port for cxgb4 allows different ports on the same PCI function
> > to be identified.
> > 
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
> 
> You've made exactly zero effort to explain why the IPV6 issue carefully
> explained in commit 8c367fcbe6549195d2eb11e62bea233f811aad41 no longer
> applies.
> 
> As far as I can tell, it absolutely does, and therefore this change
> here should not be made.
> 
> I'm not applying this patch, sorry.
> 

I have set dev_port, not dev_id. This is not a revert of commit
8c367fcbe6549195d2eb11e62bea233f811aad41.

$ git grep dev_port net/ipv6/
$

I believe dev_port was introduced exactly to solve the problem dev_id
was incorrectly being used for.

Cascardo.

