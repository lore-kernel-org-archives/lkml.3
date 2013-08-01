Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab3HAOgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:36:55 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:40057
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756272Ab3HAOgx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:36:53 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC103.redmond.corp.microsoft.com;RD:autodiscover.service.exchange.microsoft.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2fh2a8h683h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(51704005)(377454003)(189002)(199002)(13464003)(77982001)(83072001)(66066001)(19580405001)(54316002)(46102001)(77096001)(47446002)(19580395003)(56776001)(80976001)(65816001)(74366001)(4396001)(47976001)(33646001)(81342001)(31966008)(54356001)(76796001)(59766001)(76482001)(74502001)(83322001)(80022001)(76576001)(63696002)(81542001)(47736001)(74706001)(69226001)(74662001)(49866001)(74316001)(79102001)(53806001)(50986001)(76786001)(51856001)(16406001)(74876001)(56816003)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:173.61.119.57;RD:InfoNoRecords;MX:1;A:1;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Tools: hv: fix send/recv buffer allocation
Thread-Topic: [PATCH] Tools: hv: fix send/recv buffer allocation
Thread-Index: AQHOjrOkBU+WS6BJ2Ee3CgYUVtJ+dJmAak7g
Date: Thu, 1 Aug 2013 14:33:49 +0000
Message-ID: <d75531cbf7944043ad3ac96060a5e730@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1375360466-11366-1-git-send-email-olaf@aepfle.de>
In-Reply-To: <1375360466-11366-1-git-send-email-olaf@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.119.57]
x-forefront-prvs: 0925081676
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB064.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC103.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Thursday, August 01, 2013 8:34 AM
> To: KY Srinivasan; gregkh@linuxfoundation.org
> Cc: linux-kernel@vger.kernel.org; Olaf Hering
> Subject: [PATCH] Tools: hv: fix send/recv buffer allocation
> 
> hv_kvp_daemon fails to start in current openSuSE 13.1 snapshots because
> the kvp_send_buffer is too small to hold cn_msg+hv_kvp_msg, the very
> first sendmsg returns with EFAULT. In addition it fixes the Network info
> tab in Windows Server 2012R2 in SLES11.
> 
> Adjust the code in kvp and vss daemon to allocate the needed buffers at
> runtime. To keep the code simple, the buffer_len includes also the
> nlmsghdr, although only the recv_buffer needs this extra space.
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

> ---
>  tools/hv/hv_kvp_daemon.c | 15 ++++++++++++---
>  tools/hv/hv_vss_daemon.c | 15 ++++++++++++---
>  2 files changed, 24 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index 07819bf..657c1d2 100644
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -79,8 +79,6 @@ enum {
>  	DNS
>  };
> 
> -static char kvp_send_buffer[4096];
> -static char kvp_recv_buffer[4096 * 2];
>  static struct sockaddr_nl addr;
>  static int in_hand_shake = 1;
> 
> @@ -1437,10 +1435,21 @@ int main(void)
>  	int	pool;
>  	char	*if_name;
>  	struct hv_kvp_ipaddr_value *kvp_ip_val;
> +	char *kvp_send_buffer;
> +	char *kvp_recv_buffer;
> +	size_t kvp_recv_buffer_len;
> 
>  	daemon(1, 0);
>  	openlog("KVP", 0, LOG_USER);
>  	syslog(LOG_INFO, "KVP starting; pid is:%d", getpid());
> +
> +	kvp_recv_buffer_len = NLMSG_HDRLEN + sizeof(struct cn_msg) +
> sizeof(struct hv_kvp_msg);
> +	kvp_send_buffer = calloc(1, kvp_recv_buffer_len);
> +	kvp_recv_buffer = calloc(1, kvp_recv_buffer_len);
> +	if (!(kvp_send_buffer && kvp_recv_buffer)) {
> +		syslog(LOG_ERR, "Failed to allocate netlink buffers");
> +		exit(EXIT_FAILURE);
> +	}
>  	/*
>  	 * Retrieve OS release information.
>  	 */
> @@ -1514,7 +1523,7 @@ int main(void)
>  				continue;
>  		}
> 
> -		len = recvfrom(fd, kvp_recv_buffer, sizeof(kvp_recv_buffer), 0,
> +		len = recvfrom(fd, kvp_recv_buffer, kvp_recv_buffer_len, 0,
>  				addr_p, &addr_l);
> 
>  		if (len < 0) {
> diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
> index fea03a3..4c34675 100644
> --- a/tools/hv/hv_vss_daemon.c
> +++ b/tools/hv/hv_vss_daemon.c
> @@ -38,8 +38,6 @@
>  #include <linux/netlink.h>
>  #include <syslog.h>
> 
> -static char vss_recv_buffer[4096];
> -static char vss_send_buffer[4096];
>  static struct sockaddr_nl addr;
> 
>  #ifndef SOL_NETLINK
> @@ -147,6 +145,9 @@ int main(void)
>  	struct cn_msg	*incoming_cn_msg;
>  	int	op;
>  	struct hv_vss_msg *vss_msg;
> +	char *vss_send_buffer;
> +	char *vss_recv_buffer;
> +	size_t vss_recv_buffer_len;
> 
>  	if (daemon(1, 0))
>  		return 1;
> @@ -154,6 +155,14 @@ int main(void)
>  	openlog("Hyper-V VSS", 0, LOG_USER);
>  	syslog(LOG_INFO, "VSS starting; pid is:%d", getpid());
> 
> +	vss_recv_buffer_len = NLMSG_HDRLEN + sizeof(struct cn_msg) +
> sizeof(struct hv_vss_msg);
> +	vss_send_buffer = calloc(1, vss_recv_buffer_len);
> +	vss_recv_buffer = calloc(1, vss_recv_buffer_len);
> +	if (!(vss_send_buffer && vss_recv_buffer)) {
> +		syslog(LOG_ERR, "Failed to allocate netlink buffers");
> +		exit(EXIT_FAILURE);
> +	}
> +
>  	fd = socket(AF_NETLINK, SOCK_DGRAM, NETLINK_CONNECTOR);
>  	if (fd < 0) {
>  		syslog(LOG_ERR, "netlink socket creation failed; error:%d", fd);
> @@ -201,7 +210,7 @@ int main(void)
>  		pfd.revents = 0;
>  		poll(&pfd, 1, -1);
> 
> -		len = recvfrom(fd, vss_recv_buffer, sizeof(vss_recv_buffer), 0,
> +		len = recvfrom(fd, vss_recv_buffer, vss_recv_buffer_len, 0,
>  				addr_p, &addr_l);
> 
>  		if (len < 0) {
> 
> 



