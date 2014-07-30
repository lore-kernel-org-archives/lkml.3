Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbaG3T6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 15:58:43 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:12209 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969AbaG3T6l convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 15:58:41 -0400
From: "Banerjee, Debabrata" <dbanerje@akamai.com>
To: Julian Anastasov <ja@ssi.bg>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 30 Jul 2014 15:58:38 -0400
Subject: Re: [PATCH] tcp: don't require root to read tcp_metrics
Thread-Topic: [PATCH] tcp: don't require root to read tcp_metrics
Thread-Index: Ac+sMKfU8rWoTJjxQFis11S/CrHUog==
Message-ID: <CFFEC50E.38308%dbanerje@akamai.com>
References: <1406740415-9386-1-git-send-email-dbanerje@akamai.com>
 <alpine.LFD.2.11.1407302228460.1826@ja.home.ssi.bg>
In-Reply-To: <alpine.LFD.2.11.1407302228460.1826@ja.home.ssi.bg>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.4.3.140616
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 7/30/14, 3:33 PM, "Julian Anastasov" <ja@ssi.bg> wrote:
>On Wed, 30 Jul 2014, Debabrata Banerjee wrote:
>
>> commit d23ff701643a4a725e2c7a8ba2d567d39daa29ea introduced netlink
>>support for
>> the new tcp_metrics, however it restricted getting of tcp_metrics to
>>root user
>> only. This is a change from how these values could have been fetched
>>when in
>> the old route cache. Unless there's a legitimate reason to restrict the
>>reading
>> of these values it would be better if normal users could fetch them.
>
>	Not sure how fatal is to show TCP fastopen cookies to
>any user. Otherwise, I don't remember for other restrictions.


TFO cookie as reported is sent in the clear in the tcp header. It is not
the secret/key used to generate the cookie, so this should be fine.

-Debabrata

