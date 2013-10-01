Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab3JAPtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 11:49:40 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44591 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab3JAPti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 11:49:38 -0400
Message-ID: <524AEF0E.6090207@wwwdotorg.org>
Date: Tue, 01 Oct 2013 09:49:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Manish Badarkhe <badarkhe.manish@gmail.com>
CC: Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-tegra@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        rmk+kernel@arm.linux.org.uk
Subject: Re: [PATCH] regulator: tps65090: remove usage of IS_ERR_OR_NULL
References: <1380600664-20649-1-git-send-email-badarkhe.manish@gmail.com> <20131001092258.GJ19304@sirena.org.uk> <CAKDJKT6kBi_axtn+qDBkwueRGn_zzOAdSstRF=x1OqX-TrO2XQ@mail.gmail.com>
In-Reply-To: <CAKDJKT6kBi_axtn+qDBkwueRGn_zzOAdSstRF=x1OqX-TrO2XQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 08:59 AM, Manish Badarkhe wrote:
> Hi Mark,
> 
> Thank you for your reply.
> 
> On Tue, Oct 1, 2013 at 2:52 PM, Mark Brown <broonie@kernel.org> wrote:
>> On Tue, Oct 01, 2013 at 09:41:04AM +0530, Manish Badarkhe wrote:
>>> This patch changes the driver to avoid the usage of IS_ERR_OR_NULL()
>>> macro.
>>
>> Why?
> 
> Code use "IS_ERR_OR_NULL()" properly as per current implementation. But
> as per patches [1], [2] below, the use of "IS_ERR_OR_NULL()" has been
> deprecated.
> Hence done this change.

The intent was to deprecate to *concept* of checking a return value for
both NULL and an error. Simply removing usage of the macro and replacing
it with the exact same code that was part of the macro doesn't fulfil
the intent at all.
