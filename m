Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504Ab3BLSRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:17:44 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:50710 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933398Ab3BLSRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:17:42 -0500
Message-ID: <511A8743.9010408@wwwdotorg.org>
Date: Tue, 12 Feb 2013 11:17:39 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: arm@kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Julian Andres Klode <jak@jak-linux.org>,
        Marc Dietrich <marvin24@gmx.de>, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V4 1/2] get_maintainer: allow keywords to match filenames
References: <1360629574-23989-1-git-send-email-swarren@wwwdotorg.org> <1360649875.5128.18.camel@joe-AO722>
In-Reply-To: <1360649875.5128.18.camel@joe-AO722>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 11:17 PM, Joe Perches wrote:
> On Mon, 2013-02-11 at 17:39 -0700, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> Allow K: entries in MAINTAINERS to match directly against filenames;
>> either those extracted from patch +++ or --- lines, or those specified
>> on the command-line using the -f option.
> []
>> diff --git a/MAINTAINERS b/MAINTAINERS
> []
>> @@ -97,12 +97,12 @@ Descriptions of section entries:
>>  	   X:	net/ipv6/
>>  	   matches all files in and below net excluding net/ipv6/
>>  	K: Keyword perl extended regex pattern to match content in a
>> -	   patch or file.  For instance:
>> +	   patch, or an affected filename.  For instance:
> 
> The removal of file isn't correct.
> 
> This should read "patch, file or filename".
> 
> If the -f pattern is a single file,
> get_maintainer reads that file content and then
> matches any K: patterns.
> 
> When the -f pattern is a directory, it doesn't.

Yes, I guess that's true; I had convinced myself that "file" wasn't
accurate since "-f directory/" didn't scan the files within that
directory tree, but as you say "-f file" does scan the file content.

BTW, given I'm adding "filename" to the list, I intend to change the
existing "file" to "file content" to be clear. Are you OK with that?
