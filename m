Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab3CSRKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:10:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46551 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab3CSRKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:10:37 -0400
Message-ID: <51489C0A.309@wwwdotorg.org>
Date: Tue, 19 Mar 2013 11:10:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>, sameo@linux.intel.com,
        swarren@nvidia.com, gg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: palmas: initialise client->of_node for dummy created
 client
References: <1363683500-24891-1-git-send-email-ldewangan@nvidia.com> <514887D8.2020606@wwwdotorg.org> <20130319165228.GC22168@opensource.wolfsonmicro.com>
In-Reply-To: <20130319165228.GC22168@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 10:52 AM, Mark Brown wrote:
> On Tue, Mar 19, 2013 at 09:44:24AM -0600, Stephen Warren wrote:
> 
>> It seems like part of the solution here is to modify the
>> i2c_client object itself so that it can directly support devices
>> that have multiple I2C addresses; instead of 1 i2c_client
>> representing 1 address, 1 i2c_client could represent a list of
>> addresses, that list being populated directly from the list
>> contained in the top-level node's reg property. That way, you
>> wouldn't need any dummy i2c_clients, which would avoid this
>> issue.
> 
> This does then make it more complicated for all users of I2C as
> they need to become aware of such devices.  Not sure that's a
> win...

Presumably the existing APIs would work identically, and additional
APIs would be added for the complex case?
