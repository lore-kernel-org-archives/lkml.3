Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbaIHXcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 19:32:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:56347 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755009AbaIHXcH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 19:32:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,489,1406617200"; 
   d="scan'208";a="570249843"
From: "Drokin, Oleg" <oleg.drokin@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Hugues <morisset.hugues@gmail.com>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<devel@driverdev.osuosl.org>" <devel@driverdev.osuosl.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "Dilger, Andreas" <andreas.dilger@intel.com>
Subject: Re: [PATCH 4/4] staging: lustre: Fix potential buffer underflow
Thread-Topic: [PATCH 4/4] staging: lustre: Fix potential buffer underflow
Thread-Index: AQHPy7W3OeWcEqfvREW2FvQYu9Sycpv4WAIA
Date: Mon, 8 Sep 2014 23:31:41 +0000
Message-ID: <FB7D4E1C-31A3-4A86-9B3F-C00A59DCF339@intel.com>
References: <540E27FB.2070206@gmail.com> <540E287D.5090101@gmail.com>
 <540E28AD.2060607@gmail.com> <540E29B1.6090005@gmail.com>
 <20140908223853.GN6600@mwanda>
In-Reply-To: <20140908223853.GN6600@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.134.218]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <93382E1E6A7DFA4798FB88AFC858DC51@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks!

Actually, I do't think this function is useful on the client.
>From the name of it, it would have been used in the server code, but even there it was recently removed as I now see.

I'll submit a removal patch.

On Sep 8, 2014, at 6:38 PM, Dan Carpenter wrote:

> On Tue, Sep 09, 2014 at 12:12:01AM +0200, Hugues wrote:
>> Fix potential buffer underflow
>> 
>> When the string 'name' start with a '-' ptr == name and so --ptr will
>> underflow, this patch corrected this by checking ptr before decrementing.
> 
> Good eye.  Please fix up the changelog and send it inline etc and
> resend.  I've added Oleg and Andreas to the CC list so that this doesn't
> get lost.
> 
> regards,
> dan carpenter
> 
>>> From 5786040323bd1dc3149fb4afbea9f01e2bf4cfdf Mon Sep 17 00:00:00 2001
>> From: Hugues Morisset <morisset.hugues@gmail.com>
>> Date: Mon, 8 Sep 2014 22:59:04 +0200
>> Subject: [PATCH 4/4] staging: lustre: Fix potential buffer underflow
>> 
>> Signed-off-by: Hugues Morisset <morisset.hugues@gmail.com>
>> ---
>> drivers/staging/lustre/lustre/include/obd.h | 7 ++++++-
>> 1 file changed, 6 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
>> index 409eae6..bb67e40 100644
>> --- a/drivers/staging/lustre/lustre/include/obd.h
>> +++ b/drivers/staging/lustre/lustre/include/obd.h
>> @@ -677,7 +677,12 @@ static inline int is_osp_on_mdt(char *name)
>> 	if (strncmp(ptr + 1, "MDT", 3) != 0)
>> 		return 0;
>> 
>> -	while (*(--ptr) != '-' && ptr != name);
>> +	if (ptr == name)
>> +		return 0;
>> +
>> +	--ptr;
>> +	while (ptr != '-' && ptr != name)
>> +		--ptr;
>> 
>> 	if (ptr == name)
>> 		return 0;
>> -- 
>> 2.1.0
>> 
> 
>> _______________________________________________
>> devel mailing list
>> devel@linuxdriverproject.org
>> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
> 

