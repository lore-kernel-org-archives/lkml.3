Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903Ab3JOJ3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 05:29:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47036 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589Ab3JOJ3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 05:29:05 -0400
Date: Tue, 15 Oct 2013 11:28:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: Extended H/W error log driver
Message-ID: <20131015092851.GA7908@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <20131011080427.GC18719@pd.tnic>
 <20131014064940.GD12189@gchen.bj.intel.com>
 <20131014105533.GF4009@pd.tnic>
 <20131015040731.GA887@gchen.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131015040731.GA887@gchen.bj.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 12:07:31AM -0400, Chen Gong wrote:
> Some errors have multiple sub sections like below:
> 
> [ 1442.070522] {2}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 0
> [ 1442.070528] {2}[Hardware Error]: event severity: corrected
> [ 1442.070531] {2}[Hardware Error]: sub_event[0], severity: corrected
> [ 1442.070534] {2}[Hardware Error]: section_type: memory error
> [ 1442.070537] {2}[Hardware Error]: error_status: 0x0000000000000000
> [ 1442.070539] {2}[Hardware Error]: sub_event[1], severity: corrected
> [ 1442.070541] {2}[Hardware Error]: section_type: memory error
> [ 1442.070543] {2}[Hardware Error]: error_status: 0x0000000000000000

Right, and what do those sub sections mean to the user? Did we have
multiple errors?

It looks like this because we have memory errors section type but it is
not very telling. How about:


[ 1442.070522] {2}[Hardware Error]: APEI GHES id 0: Hardware errors logged
[ 1442.070528] {2}[Hardware Error]: event severity: corrected
[ 1442.070534] {2}[Hardware Error]:  Error 0, type: corrected memory error.
[ 1442.070537] {2}[Hardware Error]:   error_status: 0x0000000000000000
[ 1442.070539] {2}[Hardware Error]:  Error 1, type: corrected memory error.
[ 1442.070543] {2}[Hardware Error]:   error_status: 0x0000000000000000

I think this is much more human readable and understandable :-)

We can even add a hint for the user like:

	"Above errors have been corrected by the hardware and require no further action."

Btw, this is valid for both dmesg and trace event output.

Because from my experience so far people just scream: "Look, I just had
an MCE" withot even reading what it says. And this just upsets support
people for no valid reason at all.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
