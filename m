Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbaFZMhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 08:37:22 -0400
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:50095 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101AbaFZMhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:37:19 -0400
Date: Thu, 26 Jun 2014 09:37:09 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Hariprasad Shenai <hariprasad@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cxgb4: use dev_port to identify ports
Message-ID: <20140626123709.GA9256@oc0268524204.ibm.com>
References: <1403354888-15600-1-git-send-email-cascardo@linux.vnet.ibm.com>
 <CAB=NE6VWa4O0nycSo55ip075MEXXB_0k4wVnorSziRQmKRUmLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=NE6VWa4O0nycSo55ip075MEXXB_0k4wVnorSziRQmKRUmLg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062612-1524-0000-0000-00000A1D4549
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 04:08:21PM -0700, Luis R. Rodriguez wrote:
> On Sat, Jun 21, 2014 at 5:48 AM, Thadeu Lima de Souza Cascardo
> <cascardo@linux.vnet.ibm.com> wrote:
> > That use was removed by commit
> > 8c367fcbe6549195d2eb11e62bea233f811aad41 ("cxgb4: Do not set
> > net_device::dev_id to VI index"), since dev_id should be used only when
> > devices share the same MAC address.
> >
> > Using dev_port for cxgb4 allows different ports on the same PCI function
> > to be identified.
> 
> Can you describe what issues were introduced because of this then?
> 
>   Luis
> 

udevd builtin net-id cannot rename the interfaces, since it relies on
the dev_id for interfaces on the same PCI function. I am going to send a
patch to use dev_port instead, and fallback to dev_id, and copy netdev.

Regards.
Cascardo.

