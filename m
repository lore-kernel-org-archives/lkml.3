Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbaFJVZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 17:25:29 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47704 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbaFJVZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 17:25:28 -0400
Date: Tue, 10 Jun 2014 22:25:16 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Josh Boyer <jwboyer@redhat.com>, David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        keyrings <keyrings@linux-nfs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 0/4] KEYS: validate key trust with owner and builtin keys
 only
Message-ID: <20140610212516.GB10614@srcf.ucam.org>
References: <1402331614.7064.60.camel@dhcp-9-2-203-236.watson.ibm.com>
 <cover.1402387862.git.d.kasatkin@samsung.com>
 <20140610122008.GA31944@hansolo.jdub.homelinux.org>
 <CACE9dm9Ff6b3J=05QfcgBv-c_y=5qGNq1-ZSfo4smtj34i1e-A@mail.gmail.com>
 <20140610204021.GA8916@srcf.ucam.org>
 <CACE9dm9ma=XRZkoCiefva-dKL+LYw-s8QB4xUTkRUZH=5XM9ew@mail.gmail.com>
 <CACE9dm8zxVXx2zRcfDYUFjqvQYT4MbLevp5U13tfH9Hb6USSJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACE9dm8zxVXx2zRcfDYUFjqvQYT4MbLevp5U13tfH9Hb6USSJw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 12:17:53AM +0300, Dmitry Kasatkin wrote:

> It is probably just a paranoia...
> Kconfig MODULE_SIG_UEFI should tell about threat of loading kernel
> modules from NSA or Lenovo signed by MS or Lenovo keys..
>
> This hole is opened without warning...

It's not typically a hole. If an attacker has root they can just replace 
your bootloader with one signed by a trusted key and then have that 
modify the kernel before booting it.

If you're using a TPM then you can mitigate this, but if you have a TPM 
then you're already performing some extra steps during the boot process. 
Just add a sysfs knob that lets you drop the db keys and incorporate 
that into the TPM management code.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
