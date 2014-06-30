Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbaF3TUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 15:20:55 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:57440 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425AbaF3TUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 15:20:53 -0400
Message-ID: <1404156048.5056.5.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v6 3/6] KEYS: make partial key id matching as a
 dedicated function
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Date: Mon, 30 Jun 2014 15:20:48 -0400
In-Reply-To: <53B162C2.3070800@samsung.com>
References: <1403620852-16476-4-git-send-email-zohar@linux.vnet.ibm.com>
	 <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <7564.1403876287@warthog.procyon.org.uk> <53B162C2.3070800@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14063019-7164-0000-0000-000002CFC991
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-30 at 16:14 +0300, Dmitry Kasatkin wrote: 
> On 27/06/14 16:38, David Howells wrote:
> > Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> >
> >> +	if (strncmp(id, "id:", 3) == 0)
> 
> >> Use memcmp() here.
> 
> 'id' function parameter comes from "keys_ownerid" kernel parameter.
> User can supply anything shorter than "id:".
> Though comparing 3 bytes should not produce any memory access errors,
> memcmp can access beyond the length of the string.
> I think 'strcnmp' is more appropriate here...
> 
> 
> >> -	kid += kidlen - idlen;
> >> -	if (strcasecmp(id, kid) != 0)
> >> -		return 0;
> > This test is no longer applied in the "<subtype>:..." case.
> 
> I did not get fully what you comment here or ask to do..
> But yes, with this patch, it is no longer the case.

Other than this comment, all of the other comments have been addressed.
The updated patches are available from
linux-integrity/next-trusted-keys.

thanks,

Mimi

