Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145Ab3HGNwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 09:52:00 -0400
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:28501
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932724Ab3HGNv7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 09:51:59 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC101.redmond.corp.microsoft.com;RD:autodiscover.service.exchange.microsoft.com;EFVD:NLI
X-SpamScore: 12
X-BigFish: VS12(zfebm2f44l3416lz9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2fh2a8h683h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(51704005)(199002)(189002)(13464003)(377454003)(80976001)(47446002)(50986001)(54356001)(83072001)(47976001)(4396001)(19580405001)(79102001)(53806001)(81542001)(16406001)(51856001)(47736001)(83322001)(59766001)(65816001)(76786001)(31966008)(66066001)(80022001)(74316001)(74662001)(81342001)(74366001)(49866001)(19580395003)(76576001)(77096001)(63696002)(46102001)(56816003)(56776001)(74876001)(74706001)(76482001)(77982001)(54316002)(33646001)(69226001)(76796001)(74502001)(40753002)(121003001)(133343001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:173.61.119.57;RD:InfoNoRecords;A:1;MX:1;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Tools: hv: use full nlmsghdr in netlink_send
Thread-Topic: [PATCH] Tools: hv: use full nlmsghdr in netlink_send
Thread-Index: AQHOk3Rtnck/UDdFkUStKau9hlC7qZmJwvgg
Date: Wed, 7 Aug 2013 13:49:38 +0000
Message-ID: <2f52f51d00684e77a027157278758c84@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1375883112-20279-1-git-send-email-olaf@aepfle.de>
In-Reply-To: <1375883112-20279-1-git-send-email-olaf@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.119.57]
x-forefront-prvs: 0931CB1479
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB063.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC101.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC101.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Wednesday, August 07, 2013 9:45 AM
> To: KY Srinivasan; gregkh@linuxfoundation.org
> Cc: linux-kernel@vger.kernel.org; Olaf Hering
> Subject: [PATCH] Tools: hv: use full nlmsghdr in netlink_send
> 
> There is no need to have a nlmsghdr pointer to another temporary buffer.
> Instead use a full struct nlmsghdr.
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  tools/hv/hv_kvp_daemon.c | 15 +++++----------
>  tools/hv/hv_vss_daemon.c | 15 +++++----------
>  2 files changed, 10 insertions(+), 20 deletions(-)
> 
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index 1bd1ad1..7c05f55 100644
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -1393,23 +1393,18 @@ kvp_get_domain_name(char *buffer, int length)
>  static int
>  netlink_send(int fd, struct cn_msg *msg)
>  {
> -	struct nlmsghdr *nlh;
> +	struct nlmsghdr nlh = { .nlmsg_type = NLMSG_DONE };
>  	unsigned int size;
>  	struct msghdr message;
> -	char buffer[64];
>  	struct iovec iov[2];
> 
>  	size = sizeof(struct cn_msg) + msg->len;
> 
> -	nlh = (struct nlmsghdr *)buffer;
> -	nlh->nlmsg_seq = 0;
> -	nlh->nlmsg_pid = getpid();
> -	nlh->nlmsg_type = NLMSG_DONE;
> -	nlh->nlmsg_len = NLMSG_LENGTH(size - sizeof(*nlh));
> -	nlh->nlmsg_flags = 0;
> +	nlh.nlmsg_pid = getpid();
> +	nlh.nlmsg_len = NLMSG_LENGTH(size);
> 
> -	iov[0].iov_base = nlh;
> -	iov[0].iov_len = sizeof(*nlh);
> +	iov[0].iov_base = &nlh;
> +	iov[0].iov_len = sizeof(nlh);
> 
>  	iov[1].iov_base = msg;
>  	iov[1].iov_len = size;
> diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
> index 2f1f53f..8ac0ee7 100644
> --- a/tools/hv/hv_vss_daemon.c
> +++ b/tools/hv/hv_vss_daemon.c
> @@ -105,23 +105,18 @@ static int vss_operate(int operation)
> 
>  static int netlink_send(int fd, struct cn_msg *msg)
>  {
> -	struct nlmsghdr *nlh;
> +	struct nlmsghdr nlh = { .nlmsg_type = NLMSG_DONE };
>  	unsigned int size;
>  	struct msghdr message;
> -	char buffer[64];
>  	struct iovec iov[2];
> 
>  	size = sizeof(struct cn_msg) + msg->len;
> 
> -	nlh = (struct nlmsghdr *)buffer;
> -	nlh->nlmsg_seq = 0;
> -	nlh->nlmsg_pid = getpid();
> -	nlh->nlmsg_type = NLMSG_DONE;
> -	nlh->nlmsg_len = NLMSG_LENGTH(size - sizeof(*nlh));
> -	nlh->nlmsg_flags = 0;
> +	nlh.nlmsg_pid = getpid();
> +	nlh.nlmsg_len = NLMSG_LENGTH(size);
> 
> -	iov[0].iov_base = nlh;
> -	iov[0].iov_len = sizeof(*nlh);
> +	iov[0].iov_base = &nlh;
> +	iov[0].iov_len = sizeof(nlh);
> 
>  	iov[1].iov_base = msg;
>  	iov[1].iov_len = size;



