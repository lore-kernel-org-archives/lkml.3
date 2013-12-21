Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab3LUK5d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 05:57:33 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:49918 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3LUK5c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 05:57:32 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 21 Dec 2013 02:57:25 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kevin McKinney <klmckinney1@gmail.com>,
        Lisa Nguyen <lisa@xenapiadmin.com>,
        Lilis Iskandar <veeableful@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/2] drivers: bcm: Mark functions as static in Qos.c
Message-ID: <20131221105725.GH3611@leaf>
References: <20131221103116.GA3286@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131221103116.GA3286@rashika>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 21, 2013 at 04:01:16PM +0530, Rashika Kheria wrote:
> Mark functions MatchSrcIpAddress(), MatchDestIpAddress() and MatchTos()
> as static in Qos.c because they are not used outside this file.
> 
> This eliminates the following warnings in Qos.c:
> drivers/staging/bcm/Qos.c:27:6: warning: no previous prototype for ‘MatchSrcIpAddress’ [-Wmissing-prototypes]
> drivers/staging/bcm/Qos.c:61:6: warning: no previous prototype for ‘MatchDestIpAddress’ [-Wmissing-prototypes]
> drivers/staging/bcm/Qos.c:94:6: warning: no previous prototype for ‘MatchTos’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/staging/bcm/Qos.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/bcm/Qos.c b/drivers/staging/bcm/Qos.c
> index 1609a2b..0727599 100644
> --- a/drivers/staging/bcm/Qos.c
> +++ b/drivers/staging/bcm/Qos.c
> @@ -24,7 +24,7 @@ static VOID PruneQueue(struct bcm_mini_adapter *Adapter, INT iIndex);
>  *
>  * Returns     - TRUE(If address matches) else FAIL .
>  *********************************************************************/
> -bool MatchSrcIpAddress(struct bcm_classifier_rule *pstClassifierRule, ULONG ulSrcIP)
> +static bool MatchSrcIpAddress(struct bcm_classifier_rule *pstClassifierRule, ULONG ulSrcIP)
>  {
>  	UCHAR ucLoopIndex = 0;
>  
> @@ -58,7 +58,7 @@ bool MatchSrcIpAddress(struct bcm_classifier_rule *pstClassifierRule, ULONG ulSr
>  *
>  * Returns     - TRUE(If address matches) else FAIL .
>  *********************************************************************/
> -bool MatchDestIpAddress(struct bcm_classifier_rule *pstClassifierRule, ULONG ulDestIP)
> +static bool MatchDestIpAddress(struct bcm_classifier_rule *pstClassifierRule, ULONG ulDestIP)
>  {
>  	UCHAR ucLoopIndex = 0;
>  	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
> @@ -91,7 +91,7 @@ bool MatchDestIpAddress(struct bcm_classifier_rule *pstClassifierRule, ULONG ulD
>  *
>  * Returns     - TRUE(If address matches) else FAIL.
>  **************************************************************************/
> -bool MatchTos(struct bcm_classifier_rule *pstClassifierRule, UCHAR ucTypeOfService)
> +static bool MatchTos(struct bcm_classifier_rule *pstClassifierRule, UCHAR ucTypeOfService)
>  {
>  
>  	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
> -- 
> 1.7.9.5
> 
