Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965076Ab3DJJgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:36:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32884 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759913Ab3DJJgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:36:07 -0400
Date: Wed, 10 Apr 2013 10:35:55 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Matthew Garrett <mjg59@srcf.ucam.org>,
        Josh Boyer <jwboyer@redhat.com>, Michael Schroeder <mls@suse.com>,
        "Lee, Chun-Yi" <jlee@suse.com>, Lingzhu Xiang <lxiang@redhat.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 097/102] efivars: explicitly calculate length of
 VariableName
Message-ID: <20130410093555.GA3049@hercules>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
 <1365414657-29191-98-git-send-email-luis.henriques@canonical.com>
 <1365547506.5814.36.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365547506.5814.36.camel@deadeye.wl.decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 11:45:06PM +0100, Ben Hutchings wrote:
> On Mon, 2013-04-08 at 10:50 +0100, Luis Henriques wrote:
> > 3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Matt Fleming <matt.fleming@intel.com>
> > 
> > commit ec50bd32f1672d38ddce10fb1841cbfda89cfe9a upstream.
> > 
> > It's not wise to assume VariableNameSize represents the length of
> > VariableName, as not all firmware updates VariableNameSize in the same
> > way (some don't update it at all if EFI_SUCCESS is returned). There
> > are even implementations out there that update VariableNameSize with
> > values that are both larger than the string returned in VariableName
> > and smaller than the buffer passed to GetNextVariableName(), which
> > resulted in the following bug report from Michael Schroeder,
> > 
> >   > On HP z220 system (firmware version 1.54), some EFI variables are
> >   > incorrectly named :
> >   >
> >   > ls -d /sys/firmware/efi/vars/*8be4d* | grep -v -- -8be returns
> >   > /sys/firmware/efi/vars/dbxDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
> >   > /sys/firmware/efi/vars/KEKDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
> >   > /sys/firmware/efi/vars/SecureBoot-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
> >   > /sys/firmware/efi/vars/SetupMode-Information8be4df61-93ca-11d2-aa0d-00e098032b8c
> > 
> > The issue here is that because we blindly use VariableNameSize without
> > verifying its value, we can potentially read garbage values from the
> > buffer containing VariableName if VariableNameSize is larger than the
> > length of VariableName.
> > 
> > Since VariableName is a string, we can calculate its size by searching
> > for the terminating NULL character.
> > 
> > Reported-by: Frederic Crozat <fcrozat@suse.com>
> > Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> > Cc: Josh Boyer <jwboyer@redhat.com>
> > Cc: Michael Schroeder <mls@suse.com>
> > Cc: Lee, Chun-Yi <jlee@suse.com>
> > Cc: Lingzhu Xiang <lxiang@redhat.com>
> > Cc: Seiji Aguchi <seiji.aguchi@hds.com>
> > Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> > [ Backported for 3.4-stable. Removed workqueue code added in a93bc0c 3.9-rc1. ]
> [...]
> 
> I thought the workqueue addition was a worthwhile fix in its own right,
> so for 3.2.y I cherry-picked that as well.

Ok, makes sense to me too.  So here's what I'll do: for this release
I'll just drop this commit and e971318bbed610e28bb3fde9d548e6aaf0a6b02e
('efivars: Handle duplicate names from get_next_variable()').

I'll queue them again for next release along with commit
a93bc0c6e07ed9bac44700280e65e2945d864fd4 ('efi_pstore: Introducing
workqueue updating sysfs').

Thanks for your review Ben.

Cheers,
--
Luis
