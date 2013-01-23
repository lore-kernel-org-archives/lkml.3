Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab3AWOT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 09:19:29 -0500
Received: from pindarots.xs4all.nl ([80.101.128.228]:37174 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab3AWOT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 09:19:28 -0500
Message-ID: <50FFF15E.7010403@xs4all.nl>
Date: Wed, 23 Jan 2013 15:19:10 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
CC: Boris Ostrovsky <boris.ostrovsky@amd.com>, Jacob Shin <jacob.shin@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>,
        linux-kernel@vger.kernel.org
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
References: <50FBC7EF.6040207@xs4all.nl> <20130120103652.GB16800@pd.tnic>  <50FBC994.8020409@xs4all.nl> <20130120111920.GL25591@8bytes.org>  <50FBD413.1000406@xs4all.nl> <20130120114011.GN25591@8bytes.org>  <20130120114828.GB16519@pd.tnic> <20130121160450 <50FE9E76.30702@xs4all.nl> <50FEA3F2.1070408@amd.com> <50FEAFEB.7020103@xs4all.nl> <50FEBA69.60106@amd.com> <50FEBE5D.7040905@xs4all.nl> <50FF20F2.9090503@amd.com>
In-Reply-To: <50FF20F2.9090503@amd.com>
X-Enigmail-Version: 1.5.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-23 00:29, Suravee Suthikulanit wrote:
> I sent out a patch
> (http://marc.info/?l=linux-kernel&m=135889686523524&w=2) which should
> implement
> the workaround for AMD processor family15h model 10-1Fh erratum 746 in
> the IOMMU driver.
> In your case, the output from "setpci -s 00:00.02 F4.w" is "0050" which
> tells me that BIOS doesn't
> implement the work around. After patching, you should see the following
> message in "dmesg".
> 
> "AMD-Vi: Applying erratum 746 for IOMMU at 0000:00:00.2"

Thanks!
I'll check for that after these messages.

> The following patch slightly modify
> the code to always issue "COMPLETION_WAIT" after every command.  This
> should help increasing the chance of reproducing
> the issue.

Should I test with these two patches together?
Or should I apply the first one first and then see what the second can help?


Kind regards,
Udo
