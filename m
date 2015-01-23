Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbbAWJ40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:56:26 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:55068 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbbAWJ4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:56:21 -0500
Date: Fri, 23 Jan 2015 01:56:16 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Dudley Du <dudl@cypress.com>
Cc: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] input: cyapa: fix sparse warning issue of incorrect
 type in assiggment
Message-ID: <20150123095616.GB9314@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Dudley Du <dudl@cypress.com>,
	"dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
	"rydberg@euromail.se" <rydberg@euromail.se>,
	"bleung@google.com" <bleung@google.com>,
	"dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1421909406-1240-1-git-send-email-dudl@cypress.com>
 <20150122093129.GA7133@hudson.localdomain>
 <BN1PR06MB0701399212A030532981EA8D1490@BN1PR06MB070.namprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN1PR06MB0701399212A030532981EA8D1490@BN1PR06MB070.namprd06.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dudley,

On Thu, Jan 22, 2015 at 09:57:42AM +0000, Dudley Du wrote:
> > -----Original Message-----
> > From: Jeremiah Mahler [mailto:jmmahler@gmail.com]
> > Sent: 2015?1?22? 17:31
> > To: Dudley Du
[...]
> > >  struct gen5_bl_metadata_row_params {
> > >  __le16 size;
> > > -__le16 maximun_size;
> > > +__le16 maximum_size;
> > I don't think sparse cares about variable names.
> > Be sure to note these changes in your log.
> 
> This is a spell mistake issue, not sparse warning issue.
> Thanks.
> 
That is fine but just be sure to note that in the log.  I get suspicious
when there are changes that aren't mentioned in the log.

[...]
> > > +
> > > +if (app_integrity->flash_array_id != 0x00 ||
> > > +    get_unaligned_be16(&app_integrity->row_number) != 0x01ff) {
> > I could be wrong but it looks there are a lot of changes un-related to
> > the sparse warning.  I am not opposed to this per se but they should be
> > noted in the log message.
> 
> Understood.
> Indeed, excepted the spell error, the purpose of the changes are aimed to fix the warning issue.
> Do I need to add the log message and re-submit the patch or in other method ot change this?
> Thanks.
> 
Once I was able to reproduce the error there were quite a few.  So this
number of changes seems reasonable.

The fix is already in -next so I don't think it is a big enough problem
to worry about.

-- 
- Jeremiah Mahler
