Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423367Ab3FUQoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 12:44:09 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:58845 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161570Ab3FUQoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 12:44:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130621162455.GN11309@8bytes.org>
References: <1369250155-12226-1-git-send-email-suravee.suthikulpanit@amd.com>
	<20130621151459.GK11309@8bytes.org>
	<20130621155933.GA24385@pd.tnic>
	<20130621162455.GN11309@8bytes.org>
Date: Fri, 21 Jun 2013 10:44:06 -0600
Message-ID: <CAKocOOM42mpRRt1ziYaUfTfrsRDL5nLM=yUPEGinUvmQXA=x=w@mail.gmail.com>
Subject: Re: [PATCH 0/3] iommu/amd: IOMMU Error Reporting/Handling/Filtering
From: Shuah Khan <shuahkhan@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Borislav Petkov <bp@alien8.de>, suravee.suthikulpanit@amd.com,
        iommu@lists.linux-foundation.org, ddutile@redhat.com,
        alex.williamson@redhat.com, linux-kernel@vger.kernel.org,
        shuah.kh@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 10:24 AM, Joerg Roedel <joro@8bytes.org> wrote:
> On Fri, Jun 21, 2013 at 05:59:33PM +0200, Borislav Petkov wrote:
>> On Fri, Jun 21, 2013 at 05:15:00PM +0200, Joerg Roedel wrote:
>> > Instead of extending this bad scaling dmesg error-reporting mechanism,
>> > I would very much like to see an integration of IOMMU error handling
>> > into the EDAC framework.
>>
>> Wouldn't just adding a tracepoint and collecting the logs in debugfs be
>> enough? This would at least avoid spamming syslog with the messages.
>
> I would rather not create another user-space interface for this which we
> then have to keep forever because someone started using it. What we need
> is a well defined mechanism to report these kernel metrics to userspace
> which can then do with it whatever it wants. I think EDAC can provide
> that interface.
>

I think it makes prefect sense to use EDAC as a common frame-work for
iommu errors as well.
Especially if and when APEI evolves to cover IOMMU tables (both Intel
VT-d and AMD) , since
EDAC is already capable of working with APEI, using EDAC will work
well on platforms that support
APEI as well as the ones that don't.

-- Shuah
Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
