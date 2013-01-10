Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab3AJUvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 15:51:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22635 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab3AJUu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 15:50:59 -0500
X-Authority-Analysis: v=2.0 cv=T70Ovo2Q c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=H1xujBs8l4kA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=qb5Z4fngcp4A:10 a=D19gQVrFAAAA:8 a=OSnBdXFxrkZOW3fAiGIA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357851057.5141.16.camel@gandalf.local.home>
Subject: Re: linux-next: Tree for Jan 10 (staging/sb105x)
From: Steven Rostedt <rostedt@goodmis.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 10 Jan 2013 15:50:57 -0500
In-Reply-To: <50EF11B2.9090505@infradead.org>
References: <20130110143241.041ef77011ef7b1f68ae5c61@canb.auug.org.au>
	 <50EF11B2.9090505@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-10 at 11:08 -0800, Randy Dunlap wrote:
> On 01/09/13 19:32, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20130109:
> > 
> 
> on x86_64, when CONFIG_PARPORT_PC is not enabled:
> 
> drivers/built-in.o: In function `multi_init':
> sb_pci_mp.c:(.init.text+0x15684): undefined reference to `parport_pc_probe_port'
> 
> 
> Full randconfig file is attached.

Ug, so https://lkml.org/lkml/2012/12/14/250 should have been
CONFIG_PARPORT_PC and not just PARPORT :-P

Can you try this patch:

diff --git a/drivers/staging/sb105x/sb_pci_mp.c b/drivers/staging/sb105x/sb_pci_mp.c
index 131afd0c..9464f38 100644
--- a/drivers/staging/sb105x/sb_pci_mp.c
+++ b/drivers/staging/sb105x/sb_pci_mp.c
@@ -3054,7 +3054,7 @@ static int init_mp_dev(struct pci_dev *pcidev, mppcibrd_t brd)
 				sbdev->nr_ports = ((portnum_hex/16)*10) + (portnum_hex % 16);
 			}
 			break;
-#ifdef CONFIG_PARPORT
+#ifdef CONFIG_PARPORT_PC
 		case PCI_DEVICE_ID_MP2S1P :
 			sbdev->nr_ports = 2;
 


