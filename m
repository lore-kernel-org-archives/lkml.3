Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766AbaFKPVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:21:11 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55884 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbaFKPVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:21:07 -0400
Date: Wed, 11 Jun 2014 16:20:55 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Josh Boyer <jwboyer@redhat.com>, David Howells <dhowells@redhat.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        keyrings <keyrings@linux-nfs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 0/4] KEYS: validate key trust with owner and builtin keys
 only
Message-ID: <20140611152055.GB30253@srcf.ucam.org>
References: <CACE9dm9ma=XRZkoCiefva-dKL+LYw-s8QB4xUTkRUZH=5XM9ew@mail.gmail.com>
 <CACE9dm8zxVXx2zRcfDYUFjqvQYT4MbLevp5U13tfH9Hb6USSJw@mail.gmail.com>
 <20140610212516.GB10614@srcf.ucam.org>
 <CACE9dm95RiGxuG-XaGKd3KqBRkk+wyj3CBbMhaCTJQaiiaj9wQ@mail.gmail.com>
 <20140610214038.GA13881@srcf.ucam.org>
 <1402449893.612.14.camel@dhcp-9-2-203-236.watson.ibm.com>
 <20140611022222.GA2349@srcf.ucam.org>
 <1402456095.612.32.camel@dhcp-9-2-203-236.watson.ibm.com>
 <20140611032355.GA6470@srcf.ucam.org>
 <1402489820.612.58.camel@dhcp-9-2-203-236.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402489820.612.58.camel@dhcp-9-2-203-236.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 08:30:20AM -0400, Mimi Zohar wrote:
> On Wed, 2014-06-11 at 04:23 +0100, Matthew Garrett wrote: 
> > Yes. Wouldn't having a mechanism to allow userspace to drop keys that 
> > have otherwise been imported be a generally useful solution to the issue 
> > you have with that?
> 
> There are issues removing a key from both the local system(eg. cache,
> running apps) and the attestation server (eg. ima-sig template
> verification) perspectives.  We would need to address these concerns
> before supporting key removal.

For your use-case you'd want to do this before running any significant 
quantity of userspace. The firmware keys are going to be hashed into PCR 
7, so they're already part of your attestation.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
