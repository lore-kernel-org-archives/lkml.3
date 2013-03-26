Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964830Ab3CZPBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:01:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57922 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab3CZPBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:01:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH v2 5/6] xenvm: add a simple PSCI node and a second cpu
Date: Tue, 26 Mar 2013 15:00:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, konrad.wilk@oracle.com,
        Ian.Campbell@citrix.com, rob.herring@calxeda.com, will.deacon@arm.com,
        marc.zyngier@arm.com
References: <alpine.DEB.2.02.1303261423530.4430@kaball.uk.xensource.com> <1364308875-26484-5-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1364308875-26484-5-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303261500.53490.arnd@arndb.de>
X-Provags-ID: V02:K0:AB8KiCHw4i+Wn/Q4KEX+SlR1JnjiheB3VLgl1rJ3/KB
 S2mXknlOvUqu1ULYJdwGrT3h2zQbLa1LbLgBrgKycrZtrT+Ctv
 vulyBoA1AjYLavALRCMviupqUy06XnEUQmS20f5RAHJsK0rJpp
 0MLl9yBY65p0frvUw6CVp3feorBgnYHfTrWfRbp5nYFIaRN+ko
 p8wByHN/7tEsJt69qtq2+5QOeOv3SOSACN96gNCBS5gk/85qUm
 nTd3ab0VZkZVNYmOT7qihnym77Br8uyr6j5X8ML6w39rOP6XZv
 Kh4sZIkNl+sLqFH+ihSx3f7+/PcLpwx+4D23C/MFhpATet/BkZ
 iZKa/IinaxmLleR6qdRI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 March 2013, Stefano Stabellini wrote:
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: rob.herring@calxeda.com
> CC: will.deacon@arm.com
> CC: marc.zyngier@arm.com
> CC: arnd@arndb.de

I wonder how this is supposed to work on real systems. Shouldn't the dt
blob be filled out with the correct number of CPUs at the time you start
the guest? This change looks like you just make all guests use a hardcoded
set of two CPUs instead of just one, but you probably want to allow any
number between 1 and the number of physically present cores.

	Arnd
